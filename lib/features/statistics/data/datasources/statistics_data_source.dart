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
    int statsCount,
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
    int statsCount,
  }) async {
    final statisticsJson = await tautulliApi.getHomeStats(
      tautulliId: tautulliId,
      grouping: grouping,
      timeRange: timeRange,
      statsType: statsType,
      statsCount: statsCount,
    );

    Map<String, List<Statistics>> statisticsMap = {
      'top_tv': [],
      'popular_tv': [],
      'top_movies': [],
      'popular_movies': [],
      'top_music': [],
      'popular_music': [],
      'last_watched': [],
      'top_platforms': [],
      'top_users': [],
      'most_concurrent': [],
    };

    statisticsJson['response']['data'].forEach((statistic) {
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
