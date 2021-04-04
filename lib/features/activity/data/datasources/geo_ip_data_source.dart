import 'dart:async';

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../../core/error/exception.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
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
    @required SettingsBloc settingsBloc,
  });
}

class GeoIpDataSourceImpl implements GeoIpDataSource {
  final tautulli_api.GetGeoipLookup apiGetGeoipLookup;

  GeoIpDataSourceImpl({
    @required this.apiGetGeoipLookup,
  });

  @override
  Future<GeoIpItem> getGeoIp({
    @required String tautulliId,
    @required String ipAddress,
    @required SettingsBloc settingsBloc,
  }) async {
    final geoipJson = await apiGetGeoipLookup(
      tautulliId: tautulliId,
      ipAddress: ipAddress,
      settingsBloc: settingsBloc,
    );
    return GeoIpItemModel.fromJson(geoipJson['response']['data']);
  }
}
