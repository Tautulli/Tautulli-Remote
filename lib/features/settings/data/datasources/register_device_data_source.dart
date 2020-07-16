import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/device_info/device_info.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
import '../../domain/usecases/set_settings.dart';

abstract class RegisterDeviceDataSource {
  /// Registers the device with the Tautulli server.
  /// 
  /// Returns `true` if successful. Otherwise throws an [Exception].
  Future<bool> call({
    @required final String connectionProtocol,
    @required final String connectionDomain,
    @required final String connectionUser,
    @required final String connectionPassword,
    @required final String deviceToken,
    bool clearOnesignalId,
  });
}

class RegisterDeviceDataSourceImpl implements RegisterDeviceDataSource {
  final http.Client client;
  final SetSettings setSettings;
  final TautulliApiUrls tautulliApiUrls;
  final DeviceInfo deviceInfo;
  final OneSignalDataSource oneSignal;

  RegisterDeviceDataSourceImpl({
    @required this.client,
    @required this.setSettings,
    @required this.tautulliApiUrls,
    @required this.deviceInfo,
    @required this.oneSignal,
  });

  @override
  Future<bool> call({
    @required final String connectionProtocol,
    @required final String connectionDomain,
    @required final String connectionUser,
    @required final String connectionPassword,
    @required final String deviceToken,
    bool clearOnesignalId = false,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (connectionUser != null && connectionPassword != null) {
      headers['authorization'] = 'Basic ' +
          base64Encode(
            utf8.encode('$connectionUser:$connectionPassword'),
          );
    }

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

    final response = await client.get(
      tautulliApiUrls.registerDevice(
        protocol: connectionProtocol,
        domain: connectionDomain,
        deviceToken: deviceToken,
        deviceName: deviceName,
        deviceId: deviceId,
        onesignalId: onesignalId,
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
