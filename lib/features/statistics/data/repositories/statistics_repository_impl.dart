import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/stat_id_type.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_data_source.dart';
import '../models/statistic_model.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsDataSource dataSource;
  final NetworkInfo networkInfo;

  StatisticsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<List<StatisticModel>, bool>>> getStatistics({
    required String tautulliId,
    bool? grouping,
    int? timeRange,
    PlayMetricType? statsType,
    int? statsStart,
    int? statsCount,
    StatIdType? statId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getStatistics(
          tautulliId: tautulliId,
          grouping: grouping,
          timeRange: timeRange,
          statsType: statsType,
          statsStart: statsStart,
          statsCount: statsCount,
          statId: statId,
        );

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
