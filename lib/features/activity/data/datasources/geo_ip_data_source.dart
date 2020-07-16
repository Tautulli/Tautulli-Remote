import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../settings/domain/usecases/get_settings.dart';
import '../../domain/entities/geo_ip.dart';
import '../models/geo_ip_model.dart';

abstract class GeoIpDataSource {
  /// Returns a [GeoIpItem] for a provided IP Address.
  /// 
  /// Thows a [SettingsException] if the [connectionAddress] or 
  /// [deviceToken] are null. Throws a [ServerException] if the 
  /// server responds with a [StatusCode] other than 200.
  Future<GeoIpItem> getGeoIp(String ipAddress);
}

class GeoIpDataSourceImpl implements GeoIpDataSource {
  final http.Client client;
  final GetSettings getSettings;
  final TautulliApiUrls tautulliApiUrls;

  GeoIpDataSourceImpl({
    @required this.client,
    @required this.getSettings,
    @required this.tautulliApiUrls,
  });

  @override
  Future<GeoIpItem> getGeoIp(String ipAddress) async {
    final settings = await getSettings.load();
    final connectionAddress = settings.connectionAddress;
    final connectionProtocol = settings.connectionProtocol;
    final connectionDomain = settings.connectionDomain;
    final connectionUser = settings.connectionUser;
    final connectionPassword = settings.connectionPassword;
    final deviceToken = settings.deviceToken;

    if ((connectionAddress == null || deviceToken == null)) {
      throw SettingsException();
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (connectionUser != null && connectionPassword != null) {
      headers['authorization'] = 'Basic ' +
          base64Encode(
            utf8.encode('$connectionUser:$connectionPassword'),
          );
    }

    final response = await client.get(
      tautulliApiUrls.getGeoIpLookupUrl(
        protocol: connectionProtocol,
        domain: connectionDomain,
        deviceToken: deviceToken,
        ipAddress: ipAddress,
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return GeoIpItemModel.fromJson(responseJson['response']['data']);
    } else {
      throw ServerException();
    }
  }
}
