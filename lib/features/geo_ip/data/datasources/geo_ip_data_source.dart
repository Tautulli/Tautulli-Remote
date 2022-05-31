import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../models/geo_ip_model.dart';

abstract class GeoIpDataSource {
  Future<Tuple2<GeoIpModel, bool>> lookup({
    required String tautulliId,
    required String ipAddress,
  });
}

class GeoIpDataSourceImpl implements GeoIpDataSource {
  final GetGeoIpLookup getGeoIpLookup;

  GeoIpDataSourceImpl({
    required this.getGeoIpLookup,
  });

  @override
  Future<Tuple2<GeoIpModel, bool>> lookup({
    required String tautulliId,
    required String ipAddress,
  }) async {
    final result = await getGeoIpLookup(
      tautulliId: tautulliId,
      ipAddress: ipAddress,
    );

    return Tuple2(
        GeoIpModel.fromJson(
          result.value1['response']['data'],
        ),
        result.value2);
  }
}
