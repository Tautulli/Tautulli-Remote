import 'package:meta/meta.dart';
import 'package:version/version.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../../../core/device_info/device_info.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/requirements/versions.dart';
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
    bool clearOnesignalId,
  });
}

class RegisterDeviceDataSourceImpl implements RegisterDeviceDataSource {
  final DeviceInfo deviceInfo;
  final OneSignalDataSource oneSignal;
  final TautulliApi tautulliApi;

  RegisterDeviceDataSourceImpl({
    @required this.deviceInfo,
    @required this.oneSignal,
    @required this.tautulliApi,
  });

  @override
  Future<Map> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    bool clearOnesignalId = false,
  }) async {
    final deviceId = await deviceInfo.uniqueId;
    final deviceName = await deviceInfo.model;
    String onesignalId;

    if (clearOnesignalId == true) {
      onesignalId = '';
    } else {
      if (await oneSignal.userId != null) {
        onesignalId = await oneSignal.userId;
      } else {
        onesignalId = '';
      }
    }

    final registerJson = await tautulliApi.registerDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      deviceId: deviceId,
      deviceName: deviceName,
      onesignalId: onesignalId,
    );

    if (registerJson['response']['result'] == 'success') {
      final Map<String, dynamic> responseData =
          registerJson['response']['data'];

      // Verify sevrer meets minimum version requirement
      String tautulliVersion;
      try {
        tautulliVersion = responseData['tautulli_version'];
        if (Version.parse(tautulliVersion.substring(1)) <
            MinimumVersion.tautulliServer) {
          throw Exception;
        }
      } catch (error) {
        //TODO: Log bad version number
        await tautulliApi.deleteMobileDevice(
          connectionProtocol: connectionProtocol,
          connectionDomain: connectionDomain,
          connectionPath: connectionPath,
          deviceToken: deviceToken,
          deviceId: deviceId,
        );
        throw ServerVersionException();
      }

      return responseData;
    } else {
      throw ServerException();
    }
  }
}
