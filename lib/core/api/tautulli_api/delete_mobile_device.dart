import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class DeleteMobileDevice {
  Future<Map<String, dynamic>> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
    @required SettingsBloc settingsBloc,
  });
}

class DeleteMobileDeviceImpl implements DeleteMobileDevice {
  final ConnectionHandler connectionHandler;

  DeleteMobileDeviceImpl({@required this.connectionHandler});

  Future<Map<String, dynamic>> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      primaryConnectionProtocol: connectionProtocol,
      primaryConnectionDomain: connectionDomain,
      primaryConnectionPath: connectionPath,
      deviceToken: deviceToken,
      cmd: 'delete_mobile_device',
      params: {
        'device_id': deviceId,
      },
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
