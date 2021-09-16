// @dart=2.9

import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../features/logging/domain/usecases/logging.dart';
import '../../../features/settings/domain/usecases/settings.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../injection_container.dart' as di;
import '../../database/data/models/custom_header_model.dart';
import '../../database/domain/entities/server.dart';
import '../../error/exception.dart';
import 'call_tautulli.dart';

/// Handles failing over to the secondary connection if needed.
/// Should not be called directly.
abstract class ConnectionHandler {
  Future call({
    String tautulliId,
    String primaryConnectionProtocol,
    String primaryConnectionDomain,
    String primaryConnectionPath,
    String deviceToken,
    @required String cmd,
    Map<String, String> params,
    int timeoutOverride,
    bool trustCert,
    List<CustomHeaderModel> registerDeviceHeaders,
    SettingsBloc settingsBloc,
  });
}

class ConnectionHandlerImpl implements ConnectionHandler {
  final CallTautulli callTautulli;
  final Logging logging;

  ConnectionHandlerImpl({
    @required this.callTautulli,
    @required this.logging,
  });

  @override
  Future call({
    String tautulliId,
    String primaryConnectionProtocol,
    String primaryConnectionDomain,
    String primaryConnectionPath,
    String deviceToken,
    @required String cmd,
    Map<String, String> params,
    int timeoutOverride,
    bool trustCert = false,
    List<CustomHeaderModel> registerDeviceHeaders = const [],
    SettingsBloc settingsBloc,
  }) async {
    String secondaryConnectionAddress;
    String secondaryConnectionProtocol;
    String secondaryConnectionDomain;
    String secondaryConnectionPath;
    bool primaryActive;

    // If tautulliId is provided then query for existing server info
    if (tautulliId != null) {
      final Server server =
          await di.sl<Settings>().getServerByTautulliId(tautulliId);
      primaryConnectionProtocol = server.primaryConnectionProtocol;
      primaryConnectionDomain = server.primaryConnectionDomain;
      primaryConnectionPath = server.primaryConnectionPath;
      secondaryConnectionAddress = server.secondaryConnectionAddress;
      secondaryConnectionProtocol = server.secondaryConnectionProtocol;
      secondaryConnectionDomain = server.secondaryConnectionDomain;
      secondaryConnectionPath = server.secondaryConnectionPath;
      deviceToken = server.deviceToken;
      primaryActive = server.primaryActive;

      // Verify server has primaryConnectionAddress and deviceToken
      if (isEmpty(server.primaryConnectionAddress) ||
          isEmpty(server.deviceToken)) {
        throw SettingsException();
      }
    }
    // If no tautulliId and any primaryConnection options
    // are missing throw SettingsException.
    else if (isEmpty(primaryConnectionProtocol) ||
        isEmpty(primaryConnectionDomain) ||
        isEmpty(deviceToken)) {
      throw SettingsException();
    }

    // If primaryActive has not been set default to true
    if (primaryActive == null) {
      primaryActive = true;
    }

    var response;

    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (tautulliId != null) {
      final List<CustomHeaderModel> customHeaders =
          await di.sl<Settings>().getCustomHeadersByTautulliId(tautulliId);

      customHeaders.forEach((header) {
        headers[header.key] = header.value;
      });
    } else if (registerDeviceHeaders.isNotEmpty) {
      registerDeviceHeaders.forEach((header) {
        headers[header.key] = header.value;
      });
    }

    // Attempt to connect using active connection
    try {
      response = await callTautulli(
        connectionProtocol: primaryActive
            ? primaryConnectionProtocol
            : secondaryConnectionProtocol,
        connectionDomain:
            primaryActive ? primaryConnectionDomain : secondaryConnectionDomain,
        connectionPath:
            primaryActive ? primaryConnectionPath : secondaryConnectionPath,
        deviceToken: deviceToken,
        cmd: cmd,
        params: params,
        timeoutOverride: timeoutOverride,
        trustCert: trustCert,
        headers: headers,
      );
    } catch (error) {
      // If secondary connection configured try again with the other connection
      if (isNotEmpty(secondaryConnectionAddress)) {
        try {
          if (primaryActive) {
            logging.warning(
                'ConnectionHandler: Primary connection failed switching to secondary');
          } else {
            logging.warning(
                'ConnectionHandler: Secondary connection failed switching to primary');
          }
          primaryActive = !primaryActive;

          response = await callTautulli(
            connectionProtocol: primaryActive
                ? primaryConnectionProtocol
                : secondaryConnectionProtocol,
            connectionDomain: primaryActive
                ? primaryConnectionDomain
                : secondaryConnectionDomain,
            connectionPath:
                primaryActive ? primaryConnectionPath : secondaryConnectionPath,
            deviceToken: deviceToken,
            cmd: cmd,
            params: params,
            timeoutOverride: timeoutOverride,
            trustCert: trustCert,
            headers: headers,
          );

          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliId,
              primaryActive: primaryActive,
            ),
          );
        } catch (error) {
          // If both connections failed set primary active to true and throw error
          logging.warning('ConnectionHandler: Both connections failed');

          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliId,
              primaryActive: primaryActive,
            ),
          );

          rethrow;
        }
      } else {
        // Re-throw caught error if no secondary connection
        rethrow;
      }
    }
    return response;
  }
}
