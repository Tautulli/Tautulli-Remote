import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetSettings {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });
}

class GetSettingsImpl implements GetSettings {
  final ConnectionHandler connectionHandler;

  GetSettingsImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_settings',
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
