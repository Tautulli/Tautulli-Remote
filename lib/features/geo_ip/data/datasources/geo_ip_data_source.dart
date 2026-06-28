import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
import '../models/geo_ip_model.dart';

abstract class GeoIpDataSource {
  Future<Tuple2<GeoIpModel, bool>> lookup({
    required String tautulliId,
    required String ipAddress,
  });
}

class GeoIpDataSourceImpl implements GeoIpDataSource {
  final TautulliConnectionAdapter adapter;

  GeoIpDataSourceImpl({required this.adapter});

  @override
  Future<Tuple2<GeoIpModel, bool>> lookup({
    required String tautulliId,
    required String ipAddress,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_geoip_lookup', params: {
        'ip_address': ipAddress,
      }),
    );

    return Tuple2(GeoIpModel.fromJson(result.data['data']), result.primaryActive);
  }
}
