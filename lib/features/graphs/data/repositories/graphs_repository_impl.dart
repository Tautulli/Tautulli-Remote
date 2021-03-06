import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/graph_data.dart';
import '../../domain/repositories/graphs_repository.dart';
import '../datasources/graphs_data_source.dart';

class GraphsRepositoryImpl implements GraphsRepository {
  final GraphsDataSource dataSource;
  final NetworkInfo networkInfo;

  GraphsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, GraphData>> getPlaysByDate({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysByDate(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysByDayOfWeek({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysByDayOfWeek(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysByHourOfDay({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysByHourOfDay(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysBySourceResolution({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysBySourceResolution(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysByStreamResolution({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysByStreamResolution(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysByStreamType({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysByStreamType(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysByTop10Platforms({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysByTop10Platforms(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysByTop10Users({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysByTop10Users(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getStreamTypeByTop10Platforms({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getStreamTypeByTop10Platforms(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getStreamTypeByTop10Users({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getStreamTypeByTop10Users(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
  Future<Either<Failure, GraphData>> getPlaysPerMonth({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final graphData = await dataSource.getPlaysPerMonth(
          tautulliId: tautulliId,
          timeRange: timeRange,
          yAxis: yAxis,
          userId: userId,
          grouping: grouping,
          settingsBloc: settingsBloc,
        );
        return Right(graphData);
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
