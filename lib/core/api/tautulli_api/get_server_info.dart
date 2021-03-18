import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetServerInfo {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });
}

class GetServerInfoImpl implements GetServerInfo {
  final ConnectionHandler connectionHandler;

  GetServerInfoImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_server_info',
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
