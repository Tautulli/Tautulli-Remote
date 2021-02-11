import 'dart:async';

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../../../core/error/exception.dart';
import '../../../logging/domain/usecases/logging.dart';
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
  final tautulliApi.GetGeoipLookup apiGetGeoipLookup;
  final Logging logging;

  GeoIpDataSourceImpl({
    @required this.apiGetGeoipLookup,
    @required this.logging,
  });

  @override
  Future<GeoIpItem> getGeoIp({
    @required String tautulliId,
    @required String ipAddress,
  }) async {
    final geoipJson = await apiGetGeoipLookup(
      tautulliId: tautulliId,
      ipAddress: ipAddress,
    );
    return GeoIpItemModel.fromJson(geoipJson['response']['data']);
  }
}
