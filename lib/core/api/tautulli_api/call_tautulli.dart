// @dart=2.9

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:meta/meta.dart';

import '../../../features/logging/domain/usecases/logging.dart';
import '../../../features/settings/domain/usecases/settings.dart';
import '../../../injection_container.dart' as di;
import '../../error/exception.dart';

/// Default constructor for Tautulli API endpoints.
/// Should not be called directly.
abstract class CallTautulli {
  Future call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String cmd,
    Map<String, String> params,
    bool trustCert,
    int timeoutOverride,
    @required Map<String, String> headers,
  });
}

class CallTautulliImpl implements CallTautulli {
  final Logging logging;

  CallTautulliImpl({@required this.logging});

  @override
  Future call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String cmd,
    Map<String, String> params,
    bool trustCert,
    int timeoutOverride,
    @required Map<String, String> headers,
  }) async {
    // If no params provided initalize params
    if (params == null) {
      params = {};
    }
    params['cmd'] = cmd;
    params['apikey'] = deviceToken;
    params['app'] = 'true';

    // Construct URI based on connection protocol using the connection domain/path as well as the params
    Uri uri;
    switch (connectionProtocol) {
      case ('http'):
        uri = Uri.http('$connectionDomain', '$connectionPath/api/v2', params);
        break;
      case ('https'):
        uri = Uri.https('$connectionDomain', '$connectionPath/api/v2', params);
    }

    //* Return URI for pmsImageProxy
    if (cmd == 'pms_image_proxy') {
      return uri;
    }

    // Get timeout value from settings
    final timeout = await di.sl<Settings>().getServerTimeout();

    http.Response response;

    // Get list of custom cert hashes
    List<int> customCertHashList =
        await di.sl<Settings>().getCustomCertHashList();

    HttpClient client = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        int certHashCode = cert.pem.hashCode;

        if (cert.endValidity.isAfter(DateTime.now())) {
          if (customCertHashList.contains(certHashCode)) {
            return true;
          } else {
            if (trustCert) {
              logging.info(
                'Server Call: Saving custom cert hash for $connectionDomain',
              );
              customCertHashList.add(certHashCode);
              return true;
            }
          }
        } else if (cert.endValidity.isBefore(DateTime.now())) {
          throw CertificateExpiredException;
        }

        return false;
      });

    var ioClient = IOClient(client);

    // Call API using constructed URI
    try {
      response = await ioClient
          .get(
            uri,
            headers: headers,
          )
          .timeout(
            Duration(
              seconds: timeoutOverride != null
                  ? timeoutOverride
                  : timeout != null
                      ? timeout
                      : 5,
            ),
          );
    } catch (exception) {
      if (exception.runtimeType == HandshakeException &&
          exception.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
        throw CertificateVerificationException;
      }
      rethrow;
    }

    // Make sure to store cert list if new certs were added
    if (trustCert) {
      await di.sl<Settings>().setCustomCertHashList(customCertHashList);
    }

    // Attempt to parse reponse into JSON
    Map<String, dynamic> responseJson;
    try {
      responseJson = json.decode(response.body);
    } catch (_) {
      throw JsonDecodeException();
    }

    if (response.statusCode != 200) {
      RegExp badServerVersion = RegExp(
          r'^Device registration failed: Tautulli version v\d.\d.\d does not meet the minimum requirement of v\d.\d.\d.');

      if (responseJson['response']['message'] != null &&
          badServerVersion.hasMatch(responseJson['response']['message'])) {
        throw ServerVersionException();
      }

      throw ServerException();
    }

    return responseJson;
  }
}
