import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/repositories/geo_ip_repository.dart';
import '../datasources/geo_ip_data_source.dart';
import '../models/geo_ip_model.dart';

class GeoIpRepositoryImpl implements GeoIpRepository {
  final GeoIpDataSource dataSource;
  final NetworkInfo networkInfo;

  GeoIpRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<GeoIpModel, bool>>> lookup({
    required String tautulliId,
    required String ipAddress,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.lookup(
          tautulliId: tautulliId,
          ipAddress: ipAddress,
        );

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
