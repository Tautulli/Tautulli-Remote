// @dart=2.9

import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetUserNames {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });
}

class GetUserNamesImpl implements GetUserNames {
  final ConnectionHandler connectionHandler;

  GetUserNamesImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user_names',
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
