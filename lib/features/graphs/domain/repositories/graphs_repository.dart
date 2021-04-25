import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/graph_data.dart';

abstract class GraphsRepository {
  Future<Either<Failure, GraphData>> getPlaysByDate({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getPlaysByDayOfWeek({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getPlaysByHourOfDay({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getPlaysBySourceResolution({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getPlaysByStreamResolution({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getPlaysByStreamType({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getPlaysByTop10Platforms({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getPlaysByTop10Users({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getStreamTypeByTop10Platforms({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });

  Future<Either<Failure, GraphData>> getStreamTypeByTop10Users({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });
}
