import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class TerminateSession {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  });
}

class TerminateSessionImpl implements TerminateSession {
  final ConnectionHandler connectionHandler;

  TerminateSessionImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  }) async {
    Map<String, dynamic> params = {};
    if (sessionId != null) params['session_id'] = sessionId;
    if (sessionKey != null) params['session_key'] = sessionKey;
    if (message != null) params['message'] = message;

    final response = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'terminate_session',
      params: params,
    );

    return response;
  }
}
