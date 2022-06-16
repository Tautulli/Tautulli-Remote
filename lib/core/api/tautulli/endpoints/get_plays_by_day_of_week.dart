import 'package:dartz/dartz.dart';

import '../../../types/tautulli_types.dart';
import '../connection_handler.dart';

abstract class GetPlaysByDayOfWeek {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  });
}

class GetPlaysByDayOfWeekImpl implements GetPlaysByDayOfWeek {
  final ConnectionHandler connectionHandler;

  GetPlaysByDayOfWeekImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  }) {
    Map<String, dynamic> params = {'y_axis': yAxis};
    if (userId != null) params['user_id'] = userId;
    if (grouping != null) params['grouping'] = grouping;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_dayofweek',
      params: params,
    );

    return response;
  }
}
