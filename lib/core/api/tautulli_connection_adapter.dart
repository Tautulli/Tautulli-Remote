import 'dart:io';

import 'package:http/io_client.dart';
import 'package:tautulli/tautulli.dart' as pkg;

import '../../features/logging/domain/usecases/logging.dart';
import '../../features/settings/data/models/custom_header_model.dart';
import '../../features/settings/domain/usecases/settings.dart';
import '../error/exception.dart';
import '../types/image_fallback.dart';
import 'api_result.dart';

/// All API calls route through [call] (using server ID + automatic failover)
/// or [callDirect] (explicit connection params, used for register_device).
/// Image URIs are constructed synchronously via [buildImageUrl].
class TautulliConnectionAdapter {
  final Settings _settings;
  final Logging _logging;

  const TautulliConnectionAdapter({
    required Settings settings,
    required Logging logging,
  }) : _settings = settings,
       _logging = logging;

  /// Looks up [tautulliId] from Settings, then calls [action] on a typed
  /// [pkg.TautulliClient]. Falls over to the secondary connection on failure.
  ///
  /// Returns [ApiResult] where [ApiResult.primaryActive] reflects which
  /// connection succeeded — dispatch this via [SettingsUpdatePrimaryActive].
  Future<ApiResult<T>> call<T>({
    required String tautulliId,
    required Future<T> Function(pkg.TautulliClient client) action,
    bool trustCert = false,
  }) async {
    final server = await _settings.getServerByTautulliId(tautulliId);
    if (server == null) throw ServerNotFoundException();

    var primaryActive = server.primaryActive ?? true;

    final headers = <String, String>{'Content-Type': 'application/json'};
    for (final header in server.customHeaders) {
      headers[header.key] = header.value;
    }

    final certHashList = _settings.getCustomCertHashList();

    pkg.TautulliClient buildClient(bool usePrimary) {
      final protocol = usePrimary
          ? server.primaryConnectionProtocol
          : (server.secondaryConnectionProtocol ?? server.primaryConnectionProtocol);
      final domain = usePrimary
          ? server.primaryConnectionDomain
          : (server.secondaryConnectionDomain ?? server.primaryConnectionDomain);
      final path = usePrimary ? server.primaryConnectionPath : server.secondaryConnectionPath;
      return _buildClient(
        protocol: protocol,
        domain: domain,
        path: path,
        apiKey: server.deviceToken,
        headers: headers,
        trustCert: trustCert,
        certHashList: certHashList,
      );
    }

    T result;
    try {
      final client = buildClient(primaryActive);
      result = await action(client);
      client.close();
      if (trustCert) await _settings.setCustomCertHashList(certHashList);
    } catch (e) {
      final hasSecondary = server.secondaryConnectionAddress != null && server.secondaryConnectionAddress!.isNotEmpty;

      if (hasSecondary) {
        try {
          if (primaryActive) {
            _logging.warning('ConnectionAdapter :: Primary connection failed, switching to secondary');
          } else {
            _logging.warning('ConnectionAdapter :: Secondary connection failed, switching to primary');
          }
          primaryActive = !primaryActive;

          final client = buildClient(primaryActive);
          result = await action(client);
          client.close();
          if (trustCert) await _settings.setCustomCertHashList(certHashList);
        } catch (_) {
          primaryActive = !primaryActive;
          _logging.warning('ConnectionAdapter :: Both connections failed');
          rethrow;
        }
      } else {
        rethrow;
      }
    }

    return ApiResult(data: result, primaryActive: primaryActive);
  }

  /// Calls [action] using explicit connection parameters rather than a stored
  /// server ID. Used for [register_device] where the server may not yet exist
  /// in the local database.
  Future<ApiResult<T>> callDirect<T>({
    required String protocol,
    required String domain,
    String? path,
    required String apiKey,
    Map<String, String> extraHeaders = const {},
    List<CustomHeaderModel>? customHeaders,
    bool trustCert = false,
    required Future<T> Function(pkg.TautulliClient client) action,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json', ...extraHeaders};
    if (customHeaders != null) {
      for (final h in customHeaders) {
        headers[h.key] = h.value;
      }
    }

    final certHashList = _settings.getCustomCertHashList();
    final client = _buildClient(
      protocol: protocol,
      domain: domain,
      path: path,
      apiKey: apiKey,
      headers: headers,
      trustCert: trustCert,
      certHashList: certHashList,
    );

    try {
      final result = await action(client);
      if (trustCert) await _settings.setCustomCertHashList(certHashList);
      return ApiResult(data: result, primaryActive: true);
    } finally {
      client.close();
    }
  }

  /// Synchronous URI construction for pms_image_proxy. No HTTP call is made —
  /// the URI is passed directly to an image loading widget.
  Future<ApiResult<Uri>> buildImageUrl(
    String tautulliId, {
    String? img,
    int? ratingKey,
    int? width,
    int? height,
    int? opacity,
    int? background,
    int? blur,
    String? imgFormat,
    ImageFallback? imageFallback,
    bool? refresh,
    bool? returnHash,
  }) async {
    final server = await _settings.getServerByTautulliId(tautulliId);
    if (server == null) throw ServerNotFoundException();

    final primaryActive = server.primaryActive ?? true;

    final connection = pkg.TautulliConnection(
      protocol: primaryActive
          ? server.primaryConnectionProtocol
          : (server.secondaryConnectionProtocol ?? server.primaryConnectionProtocol),
      domain: primaryActive
          ? server.primaryConnectionDomain
          : (server.secondaryConnectionDomain ?? server.primaryConnectionDomain),
      path: primaryActive ? server.primaryConnectionPath : server.secondaryConnectionPath,
      apiKey: server.deviceToken,
      useDeviceToken: true,
    );

    final uri = pkg.ImageService(connection).buildImageUrl(
      img: img,
      ratingKey: ratingKey,
      width: width,
      height: height,
      opacity: opacity,
      background: background,
      blur: blur,
      imgFormat: imgFormat,
      fallback: imageFallback,
      refresh: refresh,
      returnHash: returnHash,
    );

    return ApiResult(data: uri, primaryActive: primaryActive);
  }

  // ---------------------------------------------------------------------------

  pkg.TautulliClient _buildClient({
    required String protocol,
    required String domain,
    String? path,
    required String apiKey,
    Map<String, String> headers = const {},
    bool trustCert = false,
    required List<int> certHashList,
  }) {
    final dartClient = HttpClient();

    dartClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      final certHash = cert.pem.hashCode;
      if (cert.endValidity.isAfter(DateTime.now())) {
        if (certHashList.contains(certHash)) return true;
        if (trustCert) {
          _logging.info('Settings :: New certificate added to trusted list');
          certHashList.add(certHash);
          return true;
        }
        // Throw so _get()'s `on TautulliException { rethrow }` propagates the correct type.
        // Returning false produces a HandshakeException whose message is platform-specific
        // and may not contain 'CERTIFICATE_VERIFY_FAILED' on all iOS/Android builds.
        throw const pkg.TautulliCertVerificationException();
      } else {
        throw const pkg.TautulliCertExpiredException();
      }
    };

    final timeout = Duration(seconds: _settings.getServerTimeout());

    return pkg.TautulliClient(
      connection: pkg.TautulliConnection(
        protocol: protocol,
        domain: domain,
        path: path,
        apiKey: apiKey,
        headers: headers,
        timeout: timeout,
        useDeviceToken: true,
      ),
      httpClient: IOClient(dartClient),
    );
  }
}
