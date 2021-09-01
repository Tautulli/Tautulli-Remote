// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/graph_data.dart';
import '../repositories/graphs_repository.dart';

class GetPlaysByHourOfDay {
  final GraphsRepository repository;

  GetPlaysByHourOfDay({@required this.repository});

  Future<Either<Failure, GraphData>> call({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getPlaysByHourOfDay(
      tautulliId: tautulliId,
      timeRange: timeRange,
      yAxis: yAxis,
      userId: userId,
      grouping: grouping,
      settingsBloc: settingsBloc,
    );
  }
}
