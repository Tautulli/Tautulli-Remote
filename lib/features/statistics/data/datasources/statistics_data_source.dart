import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/stat_id_type.dart';
import '../../../../core/utilities/cast.dart';
import '../models/statistic_data_model.dart';
import '../models/statistic_model.dart';

abstract class StatisticsDataSource {
  Future<Tuple2<List<StatisticModel>, bool>> getStatistics({
    required String tautulliId,
    bool? grouping,
    int? timeRange,
    PlayMetricType? statsType,
    int? statsStart,
    int? statsCount,
    StatIdType? statId,
  });
}

class StatisticsDataSourceImpl implements StatisticsDataSource {
  final GetHomeStats getHomeStatsApi;

  StatisticsDataSourceImpl({
    required this.getHomeStatsApi,
  });

  @override
  Future<Tuple2<List<StatisticModel>, bool>> getStatistics({
    required String tautulliId,
    bool? grouping,
    int? timeRange,
    PlayMetricType? statsType,
    int? statsStart,
    int? statsCount,
    StatIdType? statId,
  }) async {
    final result = await getHomeStatsApi(
      tautulliId: tautulliId,
      grouping: grouping,
      timeRange: timeRange,
      statsType: statsType,
      statsStart: statsStart,
      statsCount: statsCount,
      statId: statId,
    );

    List<StatisticModel> statisticModelList = [];

    dynamic responseData = result.value1['response']['data'];

    if (responseData is Iterable) {
      for (Map<String, dynamic> statGroup in responseData) {
        List<StatisticDataModel> statList = [];
        for (Map<String, dynamic> data in statGroup['rows']) {
          statList.add(StatisticDataModel.fromJson(data));
        }

        statisticModelList.add(
          StatisticModel(
            statIdType: Cast.castStringToStatIdType(statGroup['stat_id'])!,
            stats: statList,
          ),
        );
      }
    } else {
      List<StatisticDataModel> statList = [];
      for (Map<String, dynamic> data in responseData['rows']) {
        statList.add(StatisticDataModel.fromJson(data));
      }

      statisticModelList.add(
        StatisticModel(
          statIdType: Cast.castStringToStatIdType(responseData['stat_id'])!,
          stats: statList,
        ),
      );
    }

    return Tuple2(
      statisticModelList,
      result.value2,
    );
  }
}
