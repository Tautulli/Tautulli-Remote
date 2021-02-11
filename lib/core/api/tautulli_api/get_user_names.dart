import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetUserNames {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
  });
}

class GetUserNamesImpl implements GetUserNames {
  final ConnectionHandler connectionHandler;

  GetUserNamesImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user_names',
    );

    return responseJson;
  }
}
