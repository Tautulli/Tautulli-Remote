import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityDataSource dataSource;
  final NetworkInfo networkInfo;
  final FailureMapperHelper failureMapperHelper;

  ActivityRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
    @required this.failureMapperHelper,
  });

  @override
  Future<Either<Failure, List<ActivityItem>>>
      getActivity({
        @required String tautulliId,
      }) async {
    if (await networkInfo.isConnected) {
      try {
        final activity = await dataSource.getActivity(tautulliId: tautulliId);
        return Right(activity);
      } catch (exception) {
        final Failure failure =
            failureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
