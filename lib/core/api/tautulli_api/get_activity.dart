// @dart=2.9

import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

/// Returns a Map of the decoded JSON response from
/// the `get_activity` endpoint.
///
/// Throws a [JsonDecodeException] if the json decode fails.
abstract class GetActivity {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });
}

class GetActivityImpl implements GetActivity {
  final ConnectionHandler connectionHandler;

  GetActivityImpl({
    @required this.connectionHandler,
  });

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_activity',
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
