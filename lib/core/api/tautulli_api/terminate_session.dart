import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class TerminateSession {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String sessionId,
    String message,
    @required SettingsBloc settingsBloc,
  });
}

class TerminateSessionImpl implements TerminateSession {
  final ConnectionHandler connectionHandler;

  TerminateSessionImpl({@required this.connectionHandler});

  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String sessionId,
    String message,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'terminate_session',
      params: {
        'session_id': sessionId,
        'message': message,
      },
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
