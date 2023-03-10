import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../data/models/statistic_model.dart';
import '../repositories/statistics_repository.dart';

class Statistics {
  final StatisticsRepository repository;

  Statistics({required this.repository});

  /// Returns a list of `StatisticModel` each containing the `StatIdType` and a list of `StatisticDataModel`.
  Future<Either<Failure, Tuple2<List<StatisticModel>, bool>>> getStatistics({
    required String tautulliId,
    bool? grouping,
    int? timeRange,
    PlayMetricType? statsType,
    int? statsStart,
    int? statsCount,
    StatIdType? statId,
  }) async {
    return await repository.getStatistics(
      tautulliId: tautulliId,
      grouping: grouping,
      timeRange: timeRange,
      statsType: statsType,
      statsStart: statsStart,
      statsCount: statsCount,
      statId: statId,
    );
  }
}
