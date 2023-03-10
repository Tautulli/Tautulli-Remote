import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/geo_ip_model.dart';
import '../repositories/geo_ip_repository.dart';

class GeoIp {
  final GeoIpRepository repository;

  GeoIp({required this.repository});

  /// Returns a `GeoIpModel` for the provided IP address.
  Future<Either<Failure, Tuple2<GeoIpModel, bool>>> lookup({
    required String tautulliId,
    required String ipAddress,
  }) async {
    return await repository.lookup(
      tautulliId: tautulliId,
      ipAddress: ipAddress,
    );
  }
}
