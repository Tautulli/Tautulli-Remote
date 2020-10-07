import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/geo_ip.dart';
import '../../domain/repositories/geo_ip_repository.dart';
import '../datasources/geo_ip_data_source.dart';

class GeoIpRepositoryImpl implements GeoIpRepository {
  final GeoIpDataSource dataSource;
  final NetworkInfo networkInfo;

  GeoIpRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, GeoIpItem>> getGeoIp({
    @required String tautulliId,
    @required String ipAddress,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final geoIpItem = await dataSource.getGeoIp(
          tautulliId: tautulliId,
          ipAddress: ipAddress,
        );
        return Right(geoIpItem);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
