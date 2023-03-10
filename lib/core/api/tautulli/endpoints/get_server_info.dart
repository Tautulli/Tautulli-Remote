import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetServerInfo {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  });
}

class GetServerInfoImpl implements GetServerInfo {
  final ConnectionHandler connectionHandler;

  GetServerInfoImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  }) {
    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_server_info',
      params: {},
    );

    return response;
  }
}
