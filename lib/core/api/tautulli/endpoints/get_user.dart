import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetUser {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int userId,
    bool? includeLastSeen,
  });
}

class GetUserImpl implements GetUser {
  final ConnectionHandler connectionHandler;

  GetUserImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int userId,
    bool? includeLastSeen,
  }) {
    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user',
      params: {
        'user_id': userId,
        'include_last_seen': includeLastSeen ?? true,
      },
    );

    return response;
  }
}
