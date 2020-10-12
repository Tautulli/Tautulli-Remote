import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
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
  final TautulliApi tautulliApi;

  StatisticsDataSourceImpl({@required this.tautulliApi});

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
    final statisticsJson = await tautulliApi.getHomeStats(
      tautulliId: tautulliId,
      grouping: grouping,
      timeRange: timeRange,
      statsType: statsType,
      statsStart: statsStart,
      statsCount: statsCount,
      statId: statId,
    );

    Map<String, List<Statistics>> statisticsMap = {};

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

    return statisticsMap;
  }
}
