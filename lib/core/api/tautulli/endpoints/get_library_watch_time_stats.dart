import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetLibraryWatchTimeStats {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  });
}

class GetLibraryWatchTimeStatsImpl implements GetLibraryWatchTimeStats {
  final ConnectionHandler connectionHandler;

  GetLibraryWatchTimeStatsImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  }) {
    Map<String, dynamic> params = {'section_id': sectionId};
    if (grouping != null) params['grouping'] = grouping;
    if (queryDays != null) params['query_days'] = queryDays;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_library_watch_time_stats',
      params: params,
    );

    return response;
  }
}
