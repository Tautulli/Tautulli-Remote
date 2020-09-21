import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_data_source.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsDataSource dataSource;
  final NetworkInfo networkInfo;
  final FailureMapperHelper failureMapperHelper;

  StatisticsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
    @required this.failureMapperHelper,
  });

  @override
  Future<Either<Failure, Map<String, List<Statistics>>>> getStatistics({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsCount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final statisticsMap = await dataSource.getStatistics(
          tautulliId: tautulliId,
          grouping: grouping,
          statsCount: statsCount,
          statsType: statsType,
          timeRange: timeRange,
        );
        return Right(statisticsMap);
      } catch (exception) {
        final Failure failure =
            failureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
