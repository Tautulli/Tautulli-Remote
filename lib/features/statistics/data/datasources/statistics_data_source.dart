import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../domain/entities/statistics.dart';
import '../models/statistics_model.dart';

abstract class StatisticsDataSource {
  Future<Map<String, List<Statistics>>> getStatistics({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
  });
}

class StatisticsDataSourceImpl implements StatisticsDataSource {
  final tautulliApi.GetHomeStats apiGetHomeStats;

  StatisticsDataSourceImpl({@required this.apiGetHomeStats});

  @override
  Future<Map<String, List<Statistics>>> getStatistics({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
  }) async {
    final statisticsJson = await apiGetHomeStats(
      tautulliId: tautulliId,
      grouping: grouping,
      timeRange: timeRange,
      statsType: statsType,
      statsStart: statsStart,
      statsCount: statsCount,
      statId: statId,
    );

    Map<String, List<Statistics>> statisticsMap = {};

    if (statId == null) {
      statisticsJson['response']['data'].forEach((statistic) {
        statisticsMap[statistic['stat_id']] = [];
        statistic['rows'].forEach((item) {
          statisticsMap[statistic['stat_id']].add(
            StatisticsModel.fromJson(
              statId: statistic['stat_id'],
              json: item,
            ),
          );
        });
      });
    } else {
      statisticsMap[statId] = [];
      statisticsJson['response']['data']['rows'].forEach((item) {
        statisticsMap[statId].add(
          StatisticsModel.fromJson(
            statId: statId,
            json: item,
          ),
        );
      });
    }

    return statisticsMap;
  }
}
