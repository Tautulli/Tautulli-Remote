import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/geo_ip.dart';
import '../repositories/geo_ip_repository.dart';

class GetGeoIp {
  final GeoIpRepository repository;

  GetGeoIp({@required this.repository});

  Future<Either<Failure, GeoIpItem>> call({
    @required String plexName,
    @required String ipAddress,
  }) async {
    return await repository.getGeoIp(
      plexName: plexName,
      ipAddress: ipAddress,
    );
  }
}
