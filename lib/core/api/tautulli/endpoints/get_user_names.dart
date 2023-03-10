import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetUserNames {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  });
}

class GetUserNamesImpl implements GetUserNames {
  final ConnectionHandler connectionHandler;

  GetUserNamesImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  }) {
    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user_names',
      params: {},
    );

    return response;
  }
}
