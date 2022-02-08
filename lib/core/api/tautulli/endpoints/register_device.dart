import 'package:dartz/dartz.dart';

import '../../../../features/settings/data/models/custom_header_model.dart';
import '../../../requirements/tautulli_version.dart';
import '../connection_handler.dart';

abstract class RegisterDevice {
  Future<Tuple2<dynamic, bool>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    required String deviceId,
    required String deviceName,
    required String onesignalId,
    required String platform,
    required String version,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert,
  });
}

class RegisterDeviceImpl implements RegisterDevice {
  final ConnectionHandler connectionHandler;

  RegisterDeviceImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    required String deviceId,
    required String deviceName,
    required String onesignalId,
    required String platform,
    required String version,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert = false,
  }) async {
    final response = await connectionHandler(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
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
      customHeaders: customHeaders,
      trustCert: trustCert,
    );

    return response;
  }
}
