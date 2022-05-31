import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetGeoIpLookup {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required String ipAddress,
  });
}

class GetGeoIpLookupImpl implements GetGeoIpLookup {
  final ConnectionHandler connectionHandler;

  GetGeoIpLookupImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required String ipAddress,
  }) {
    Map<String, dynamic> params = {'ip_address': ipAddress};

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_geoip_lookup',
      params: params,
    );

    return response;
  }
}
