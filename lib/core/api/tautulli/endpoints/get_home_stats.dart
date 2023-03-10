import 'package:dartz/dartz.dart';

import '../../../types/tautulli_types.dart';
import '../connection_handler.dart';

abstract class GetHomeStats {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    bool? grouping,
    int? timeRange,
    PlayMetricType? statsType,
    int? statsStart,
    int? statsCount,
    StatIdType? statId,
  });
}

class GetHomeStatsImpl implements GetHomeStats {
  final ConnectionHandler connectionHandler;

  GetHomeStatsImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    bool? grouping,
    int? timeRange,
    PlayMetricType? statsType,
    int? statsStart,
    int? statsCount,
    StatIdType? statId,
  }) {
    Map<String, dynamic> params = {};
    if (grouping != null) params['grouping'] = grouping;
    if (timeRange != null) params['time_range'] = timeRange;
    if (statsType != null) params['stats_type'] = statsType;
    if (statsStart != null) params['stats_start'] = statsStart;
    if (statsCount != null) params['stats_count'] = statsCount;
    if (statId != null) params['stat_id'] = statId;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_home_stats',
      params: params,
    );

    return response;
  }
}
