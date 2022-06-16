import 'package:dartz/dartz.dart';

import '../../../types/tautulli_types.dart';
import '../connection_handler.dart';

abstract class GetPlaysByTop10Platforms {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required GraphYAxis yAxis,
    int? userId,
    bool? grouping,
  });
}

class GetPlaysByTop10PlatformsImpl implements GetPlaysByTop10Platforms {
  final ConnectionHandler connectionHandler;

  GetPlaysByTop10PlatformsImpl(this.connectionHandler);

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
      cmd: 'get_plays_by_top_10_platforms',
      params: params,
    );

    return response;
  }
}
