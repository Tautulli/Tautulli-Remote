import 'dart:io';

import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../../core/device_info/device_info.dart';
import '../../../../core/error/exception.dart';
import '../../../onesignal/data/datasources/onesignal_data_source.dart';

abstract class RegisterDeviceDataSource {
  /// Registers the device with the Tautulli server.
  ///
  /// Returns Map with registration data if successful. Otherwise throws an [Exception].
  Future<Map> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    bool trustCert,
  });
}

class RegisterDeviceDataSourceImpl implements RegisterDeviceDataSource {
  final DeviceInfo deviceInfo;
  final OneSignalDataSource oneSignal;
  final tautulli_api.RegisterDevice apiRegisterDevice;

  RegisterDeviceDataSourceImpl({
    @required this.deviceInfo,
    @required this.oneSignal,
    @required this.apiRegisterDevice,
  });

  @override
  Future<Map> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    bool trustCert,
  }) async {
    final deviceId = await deviceInfo.uniqueId;
    final deviceName = await deviceInfo.model;
    String onesignalId = await oneSignal.userId;

    final registerJson = await apiRegisterDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      deviceId: deviceId,
      deviceName: deviceName,
      onesignalId: isNotEmpty(onesignalId) ? onesignalId : 'onesignal-disabled',
      platform: Platform.isIOS ? 'ios' : 'android',
      trustCert: trustCert,
    );

    if (registerJson['response']['result'] == 'success') {
      final Map<String, dynamic> responseData =
          registerJson['response']['data'];

      if (!responseData.containsKey('tautulli_version')) {
        throw ServerVersionException();
      }

      return responseData;
    } else {
      throw ServerException();
    }
  }
}
