import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../data/models/statistic_model.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, Tuple2<List<StatisticModel>, bool>>> getStatistics({
    required String tautulliId,
    bool? grouping,
    int? timeRange,
    PlayMetricType? statsType,
    int? statsStart,
    int? statsCount,
    StatIdType? statId,
  });
}
