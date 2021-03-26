import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetUser {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
}

class GetUserImpl implements GetUser {
  final ConnectionHandler connectionHandler;

  GetUserImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user',
      params: {
        'user_id': userId.toString(),
      },
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
