import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/geo_ip.dart';

import '../repositories/geo_ip_repository.dart';

class GetGeoIp {
  final GeoIpRepository repository;

  GetGeoIp({@required this.repository});

  Future<Either<Failure, GeoIpItem>> call(String ipAddress) async {
    return await repository.getGeoIp(ipAddress);
  }
}
