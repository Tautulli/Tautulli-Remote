import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetUserWatchTimeStats {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  });
}

class GetUserWatchTimeStatsImpl implements GetUserWatchTimeStats {
  final ConnectionHandler connectionHandler;

  GetUserWatchTimeStatsImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  }) {
    Map<String, dynamic> params = {
      'user_id': userId,
    };

    if (grouping != null) params['grouping'] = grouping;
    if (queryDays != null) params['query_days'] = queryDays;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user_watch_time_stats',
      params: params,
    );

    return response;
  }
}
