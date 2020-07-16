import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/geo_ip.dart';

abstract class GeoIpRepository {
  Future<Either<Failure, GeoIpItem>> getGeoIp(String ipAddress);
}