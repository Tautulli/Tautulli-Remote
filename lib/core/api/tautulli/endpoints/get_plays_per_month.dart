import 'package:dartz/dartz.dart';

import '../../../types/tautulli_types.dart';
import '../connection_handler.dart';

abstract class GetPlaysPerMonth {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required PlayMetricType yAxis,
    required int timeRange,
    int? userId,
    bool? grouping,
  });
}

class GetPlaysPerMonthImpl implements GetPlaysPerMonth {
  final ConnectionHandler connectionHandler;

  GetPlaysPerMonthImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
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

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_plays_per_month',
      params: params,
    );

    return response;
  }
}
