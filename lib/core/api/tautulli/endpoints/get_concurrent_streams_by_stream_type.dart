import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetConcurrentStreamsByStreamType {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int timeRange,
    int? userId,
  });
}

class GetConcurrentStreamsByStreamTypeImpl implements GetConcurrentStreamsByStreamType {
  final ConnectionHandler connectionHandler;

  GetConcurrentStreamsByStreamTypeImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int timeRange,
    int? userId,
  }) {
    Map<String, dynamic> params = {
      'time_range': timeRange,
    };
    if (userId != null) params['user_id'] = userId;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_concurrent_streams_by_stream_type',
      params: params,
    );

    return response;
  }
}
