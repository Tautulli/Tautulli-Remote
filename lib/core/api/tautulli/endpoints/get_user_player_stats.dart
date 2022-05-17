import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetUserPlayerStats {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int userId,
    bool? grouping,
  });
}

class GetUserPlayerStatsImpl implements GetUserPlayerStats {
  final ConnectionHandler connectionHandler;

  GetUserPlayerStatsImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int userId,
    bool? grouping,
  }) {
    Map<String, dynamic> params = {
      'user_id': userId,
    };

    if (grouping != null) params['grouping'] = grouping;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user_player_stats',
      params: params,
    );

    return response;
  }
}
