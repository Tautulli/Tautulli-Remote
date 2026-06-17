import 'package:dartz/dartz.dart';

import '../../../types/tautulli_types.dart';
import '../connection_handler.dart';

abstract class GetPlaysByGraphType {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required String cmd,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });
}

class GetPlaysByGraphTypeImpl implements GetPlaysByGraphType {
  final ConnectionHandler connectionHandler;

  GetPlaysByGraphTypeImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required String cmd,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  }) {
    Map<String, dynamic> params = {
      'y_axis': yAxis,
      'time_range': timeRange,
    };
    if (userId != null) params['user_id'] = userId;
    if (grouping != null) params['grouping'] = grouping;

    return connectionHandler(
      tautulliId: tautulliId,
      cmd: cmd,
      params: params,
    );
  }
}
