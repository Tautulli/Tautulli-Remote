import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
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
    int statsCount,
  }) async {
    return await repository.getStatistics(
      tautulliId: tautulliId,
      grouping: grouping,
      statsCount: statsCount,
      statsType: statsType,
      timeRange: timeRange,
    );
  }
}
