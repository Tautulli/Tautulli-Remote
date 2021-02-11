import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetSettings {
  Future<Map<String, dynamic>> call(String tautulliId);
}

class GetSettingsImpl implements GetSettings {
  final ConnectionHandler connectionHandler;

  GetSettingsImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call(String tautulliId) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_settings',
    );

    return responseJson;
  }
}
