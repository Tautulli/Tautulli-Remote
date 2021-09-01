// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library_statistic.dart';
import '../../domain/repositories/library_statistics_repository.dart';
import '../datasources/library_statistics_data_source.dart';

class LibraryStatisticsRepositoryImpl implements LibraryStatisticsRepository {
  final LibraryStatisticsDataSource dataSource;
  final NetworkInfo networkInfo;

  LibraryStatisticsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LibraryStatistic>>> getLibraryWatchTimeStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final libraryWatchTimeStatsList =
            await dataSource.getLibraryWatchTimeStats(
          tautulliId: tautulliId,
          sectionId: sectionId,
          settingsBloc: settingsBloc,
        );
        return Right(libraryWatchTimeStatsList);
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
  Future<Either<Failure, List<LibraryStatistic>>> getLibraryUserStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final libraryUserStatsList = await dataSource.getLibraryUserStats(
          tautulliId: tautulliId,
          sectionId: sectionId,
          settingsBloc: settingsBloc,
        );
        return Right(libraryUserStatsList);
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
