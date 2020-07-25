import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/device_info/device_info.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
import '../../domain/usecases/settings.dart';

abstract class RegisterDeviceDataSource {
  /// Registers the device with the Tautulli server.
  ///
  /// Returns `true` if successful. Otherwise throws an [Exception].
  Future<Map> call({
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
  final Settings settings;
  final TautulliApiUrls tautulliApiUrls;
  final DeviceInfo deviceInfo;
  final OneSignalDataSource oneSignal;

  RegisterDeviceDataSourceImpl({
    @required this.client,
    @required this.settings,
    @required this.tautulliApiUrls,
    @required this.deviceInfo,
    @required this.oneSignal,
  });

  @override
  Future<Map> call({
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
    ).timeout(Duration(seconds: 3));

    

    if (response.statusCode == 200) {
      try {
        final responseJson = json.decode(response.body);
        if (responseJson['response']['result'] == 'success') {
          final Map<String, dynamic> responseData = responseJson['response']['data'];
          return responseData;
        } else {
          throw ServerException();
        }
      } catch (error) {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}
