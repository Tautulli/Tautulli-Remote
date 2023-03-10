import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_data_source.dart';
import '../models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityDataSource dataSource;
  final NetworkInfo networkInfo;

  ActivityRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<List<ActivityModel>, bool>>> getActivity({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getActivity(
          tautulliId: tautulliId,
          sessionKey: sessionKey,
          sessionId: sessionId,
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

  @override
  Future<Either<Failure, Tuple2<void, bool>>> terminateStream({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.terminateStream(
          tautulliId: tautulliId,
          sessionId: sessionId,
          sessionKey: sessionKey,
          message: message,
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
