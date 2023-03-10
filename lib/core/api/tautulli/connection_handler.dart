import 'package:dartz/dartz.dart';
import 'package:quiver/strings.dart';

import '../../../dependency_injection.dart' as di;
import '../../../features/logging/domain/usecases/logging.dart';
import '../../../features/settings/data/models/custom_header_model.dart';
import '../../../features/settings/domain/usecases/settings.dart';
import '../../error/exception.dart';
import 'call_tautulli.dart';

abstract class ConnectionHandler {
  /// Requires either the Tautulli ID or the connection protocol,
  /// domain, path, and device token.
  ///
  /// Returns a `Tuple` containing the `dynamic` Tautulli server `responseData` and the
  /// current `bool` state of `primaryActive`.
  Future<Tuple2<dynamic, bool>> call({
    String? tautulliId,
    String? connectionProtocol,
    String? connectionDomain,
    String? connectionPath,
    String? deviceToken,
    required String cmd,
    required Map<String, dynamic> params,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert,
    int? timeoutOverride,
  });
}

class ConnectionHandlerImpl implements ConnectionHandler {
  final CallTautulli callTautulli;

  ConnectionHandlerImpl(this.callTautulli);

  @override
  Future<Tuple2<dynamic, bool>> call({
    String? tautulliId,
    String? connectionProtocol,
    String? connectionDomain,
    String? connectionPath,
    String? deviceToken,
    required String cmd,
    required Map<String, dynamic> params,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert = false,
    int? timeoutOverride,
  }) async {
    if ((tautulliId == null) ||
        (connectionProtocol != null ||
            connectionDomain != null ||
            connectionPath != null ||
            deviceToken != null)) {
      assert(
        tautulliId != null ||
            (connectionProtocol != null &&
                connectionDomain != null &&
                connectionPath != null &&
                deviceToken != null),
        'Requires either the Tautulli ID or the connection protocol, domain, path, and device token.',
      );
    }

    String? secondaryConnectionAddress;
    String? secondaryConnectionProtocol;
    String? secondaryConnectionDomain;
    String? secondaryConnectionPath;
    bool? primaryActive;
    Map<String, String> headers = {'Content-Type': 'application/json'};

    // If using Tautulli ID to fetch existing server details
    if (isNotBlank(tautulliId)) {
      final server = await di.sl<Settings>().getServerByTautulliId(tautulliId!);
      if (server != null) {
        connectionProtocol = server.primaryConnectionProtocol;
        connectionDomain = server.primaryConnectionDomain;
        connectionPath = server.primaryConnectionPath;
        secondaryConnectionAddress = server.secondaryConnectionAddress;
        secondaryConnectionProtocol = server.secondaryConnectionProtocol;
        secondaryConnectionDomain = server.secondaryConnectionDomain;
        secondaryConnectionPath = server.secondaryConnectionPath;
        deviceToken = server.deviceToken;
        primaryActive = server.primaryActive;

        // Parse custom headers for existing server
        for (CustomHeaderModel header in server.customHeaders) {
          headers[header.key] = header.value;
        }
      } else {
        throw ServerNotFoundException();
      }
    }

    // If primaryActive has not been set, default to true
    primaryActive ??= true;

    // Parse custom headers provided when Tautulli ID is blank.
    if (isBlank(tautulliId)) {
      if (customHeaders != null) {
        for (CustomHeaderModel customHeader in customHeaders) {
          headers[customHeader.key] = customHeader.value;
        }
      }
    }

    Either<Uri, dynamic> responseData;
    // Try making the call to Tautulli using the active connection details.
    //
    // If that fails, and there are secondary connection details, swap the
    // active connection and try again.
    //
    // If that again fails throw the error.
    try {
      responseData = await callTautulli(
        connectionProtocol:
            primaryActive ? connectionProtocol! : secondaryConnectionProtocol!,
        connectionDomain:
            primaryActive ? connectionDomain! : secondaryConnectionDomain!,
        connectionPath:
            primaryActive ? connectionPath : secondaryConnectionPath,
        deviceToken: deviceToken!,
        cmd: cmd,
        params: params,
        trustCert: trustCert,
        timeoutOverride: timeoutOverride,
        headers: headers,
      );
    } catch (e) {
      // If a secondary connection address is configured swap the active
      // connection and try again. Otherwise, throw the error.
      if (isNotBlank(secondaryConnectionAddress)) {
        try {
          if (primaryActive) {
            di.sl<Logging>().warning(
                  'ConnectionHandler :: Primary connection failed switching to secondary',
                );
          } else {
            di.sl<Logging>().warning(
                  'ConnectionHandler :: Secondary connection failed switching to primary',
                );
          }

          // Swap the active connection
          primaryActive = !primaryActive;

          responseData = await callTautulli(
            connectionProtocol: primaryActive
                ? connectionProtocol!
                : secondaryConnectionProtocol!,
            connectionDomain:
                primaryActive ? connectionDomain! : secondaryConnectionDomain!,
            connectionPath:
                primaryActive ? connectionPath : secondaryConnectionPath,
            deviceToken: deviceToken!,
            cmd: cmd,
            params: params,
            trustCert: trustCert,
            timeoutOverride: timeoutOverride,
            headers: headers,
          );
        } catch (e) {
          // If both connections failed set primary active to true and throw error
          primaryActive = !primaryActive!;
          di.sl<Logging>().warning(
                'ConnectionHandler :: Both connections failed',
              );

          rethrow;
        }
      } else {
        rethrow;
      }
    }

    return responseData.fold(
      (uri) => Tuple2(uri, primaryActive!),
      (apiResponse) => Tuple2(apiResponse, primaryActive!),
    );
  }
}
