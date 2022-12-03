import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetActivity {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  });
}

class GetActivityImpl implements GetActivity {
  final ConnectionHandler connectionHandler;

  GetActivityImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  }) {
    Map<String, dynamic> params = {};
    if (sessionKey != null) params['session_key'] = sessionKey;
    if (sessionId != null) params['session_id'] = sessionId;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_activity',
      params: params,
    );

    return response;
  }
}
