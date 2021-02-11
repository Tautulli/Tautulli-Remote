import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetServerInfo {
  Future<Map<String, dynamic>> call(String tautulliId);
}

class GetServerInfoImpl implements GetServerInfo {
  final ConnectionHandler connectionHandler;

  GetServerInfoImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call(String tautulliId) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_server_info',
    );

    return responseJson;
  }
}
