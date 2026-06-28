// ignore_for_file: use_null_aware_elements

import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
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
  final TautulliConnectionAdapter adapter;

  StatisticsDataSourceImpl({required this.adapter});

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
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_home_stats', params: {
        if (grouping != null) 'grouping': grouping ? 1 : 0,
        if (timeRange != null) 'time_range': timeRange,
        if (statsType != null) 'stats_type': statsType.value,
        if (statsStart != null) 'stats_start': statsStart,
        if (statsCount != null) 'stats_count': statsCount,
        if (statId != null) 'stat_id': statId.value,
      }),
    );

    List<StatisticModel> statisticModelList = [];
    final dynamic responseData = result.data['data'];

    if (responseData is Iterable) {
      for (Map<String, dynamic> statGroup in responseData) {
        final List<StatisticDataModel> statList = [];
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
      final List<StatisticDataModel> statList = [];
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

    return Tuple2(statisticModelList, result.primaryActive);
  }
}
