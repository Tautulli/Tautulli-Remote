import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/statistics.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, Map<String, List<Statistics>>>> getStatistics({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
    @required SettingsBloc settingsBloc,
  });
}
