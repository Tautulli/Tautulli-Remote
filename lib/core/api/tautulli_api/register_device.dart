// @dart=2.9

import 'package:meta/meta.dart';

import '../../database/data/models/custom_header_model.dart';
import '../../requirements/versions.dart';
import 'connection_handler.dart';

abstract class RegisterDevice {
  Future<Map<String, dynamic>> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
    @required String deviceName,
    @required String onesignalId,
    @required String platform,
    @required String version,
    List<CustomHeaderModel> headers,
    bool trustCert,
  });
}

class RegisterDeviceImpl implements RegisterDevice {
  final ConnectionHandler connectionHandler;

  RegisterDeviceImpl({@required this.connectionHandler});

  Future<Map<String, dynamic>> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
    @required String deviceName,
    @required String onesignalId,
    @required String platform,
    @required String version,
    bool trustCert,
    List<CustomHeaderModel> headers,
  }) async {
    final responseJson = await connectionHandler(
      primaryConnectionProtocol: connectionProtocol,
      primaryConnectionDomain: connectionDomain,
      primaryConnectionPath: connectionPath,
      deviceToken: deviceToken,
      cmd: 'register_device',
      params: {
        'device_name': deviceName,
        'device_id': deviceId,
        'onesignal_id': onesignalId,
        'min_version': 'v${MinimumVersion.tautulliServer}',
        'platform': platform,
        'version': version,
      },
      registerDeviceHeaders: headers,
      trustCert: trustCert,
    );

    return responseJson;
  }
}
