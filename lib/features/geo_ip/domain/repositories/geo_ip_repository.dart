import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/geo_ip_model.dart';

abstract class GeoIpRepository {
  Future<Either<Failure, Tuple2<GeoIpModel, bool>>> lookup({
    required String tautulliId,
    required String ipAddress,
  });
}
