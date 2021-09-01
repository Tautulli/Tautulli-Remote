// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_statistic.dart';
import '../../domain/repositories/user_statistics_repository.dart';
import '../datasources/user_statistics_data_source.dart';

class UserStatisticsRepositoryImpl implements UserStatisticsRepository {
  final UserStatisticsDataSource dataSource;
  final NetworkInfo networkInfo;

  UserStatisticsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UserStatistic>>> getUserWatchTimeStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userWatchTimeStatsList = await dataSource.getUserWatchTimeStats(
          tautulliId: tautulliId,
          userId: userId,
          settingsBloc: settingsBloc,
        );
        return Right(userWatchTimeStatsList);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserStatistic>>> getUserPlayerStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userPlayerStatsList = await dataSource.getUserPlayerStats(
          tautulliId: tautulliId,
          userId: userId,
          settingsBloc: settingsBloc,
        );
        return Right(userPlayerStatsList);
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
