import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../domain/entities/geo_ip.dart';
import '../models/geo_ip_model.dart';

abstract class GeoIpDataSource {
  /// Returns a [GeoIpItem] for a provided IP Address.
  ///
  /// Thows a [SettingsException] if the [connectionAddress] or
  /// [deviceToken] are null. Throws a [ServerException] if the
  /// server responds with a [StatusCode] other than 200.
  Future<GeoIpItem> getGeoIp({
    @required String tautulliId,
    @required String ipAddress,
  });
}

class GeoIpDataSourceImpl implements GeoIpDataSource {
  final http.Client client;
  final Settings settings;
  final TautulliApiUrls tautulliApiUrls;
  final Logging logging;

  GeoIpDataSourceImpl({
    @required this.client,
    @required this.settings,
    @required this.tautulliApiUrls,
    @required this.logging,
  });

  @override
  Future<GeoIpItem> getGeoIp({
    @required String tautulliId,
    @required String ipAddress,
  }) async {
    final Server server = await settings.getServerByTautulliId(tautulliId);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    http.Response response;

    try {
      if (isNotEmpty(server.primaryConnectionUser) &&
          isNotEmpty(server.primaryConnectionPassword)) {
        headers['authorization'] = 'Basic ' +
            base64Encode(
              utf8.encode(
                  '${server.primaryConnectionUser}:${server.primaryConnectionPassword}'),
            );
      }

      response = await client
          .get(
            tautulliApiUrls.getGeoIpLookupUrl(
              protocol: server.primaryConnectionProtocol,
              domain: server.primaryConnectionDomain,
              deviceToken: server.deviceToken,
              ipAddress: ipAddress,
            ),
            headers: headers,
          )
          .timeout(
            Duration(seconds: 5),
          );
    } catch (error) {
      if (error == TimeoutException) {
        logging.error('GeoIP Lookup: Primary connection timed out.');

        try {
          if (isNotEmpty(server.secondaryConnectionUser) &&
              isNotEmpty(server.secondaryConnectionPassword)) {
            headers['authorization'] = 'Basic ' +
                base64Encode(
                  utf8.encode(
                      '${server.secondaryConnectionUser}:${server.secondaryConnectionPassword}'),
                );
          }

          response = await client
              .get(
                tautulliApiUrls.getGeoIpLookupUrl(
                  protocol: server.secondaryConnectionProtocol,
                  domain: server.secondaryConnectionDomain,
                  deviceToken: server.deviceToken,
                  ipAddress: ipAddress,
                ),
                headers: headers,
              )
              .timeout(
                Duration(seconds: 5),
              );
        } catch (error) {
          if (error == TimeoutException) {
            logging.error('GeoIP Lookup: Secondary connection timed out.');
          }
          throw error;
        }
      } else {
        // If error is not a TimeoutException throw to be caught by repository
        throw error;
      }
    }

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return GeoIpItemModel.fromJson(responseJson['response']['data']);
    } else {
      throw ServerException();
    }
  }
}
