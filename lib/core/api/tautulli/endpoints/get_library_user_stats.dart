import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetLibraryUserStats {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  });
}

class GetLibraryUserStatsImpl implements GetLibraryUserStats {
  final ConnectionHandler connectionHandler;

  GetLibraryUserStatsImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  }) {
    Map<String, dynamic> params = {'section_id': sectionId};
    if (grouping != null) params['grouping'] = grouping;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_library_user_stats',
      params: params,
    );

    return response;
  }
}
