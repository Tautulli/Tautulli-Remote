import 'package:meta/meta.dart';

import 'connection_handler.dart';

/// Returns a Map of the decoded JSON response from
/// the `get_activity` endpoint.
///
/// Throws a [JsonDecodeException] if the json decode fails.
abstract class GetActivity {
  Future<Map<String, dynamic>> call(String tautulliId);
}

class GetActivityImpl implements GetActivity {
  final ConnectionHandler connectionHandler;

  GetActivityImpl({
    @required this.connectionHandler,
  });

  @override
  Future<Map<String, dynamic>> call(String tautulliId) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_activity',
    );

    return responseJson;
  }
}
