// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/statistics.dart';
import '../repositories/statistics_repository.dart';

class GetStatistics {
  final StatisticsRepository repository;

  GetStatistics({@required this.repository});

  Future<Either<Failure, Map<String, List<Statistics>>>> call({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getStatistics(
      tautulliId: tautulliId,
      grouping: grouping,
      statsCount: statsCount,
      statId: statId,
      statsStart: statsStart,
      statsType: statsType,
      timeRange: timeRange,
      settingsBloc: settingsBloc,
    );
  }
}
