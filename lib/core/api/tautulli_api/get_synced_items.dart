import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetSyncedItems {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    String machineId,
    int userId,
    @required SettingsBloc settingsBloc,
  });
}

class GetSyncedItemsImpl implements GetSyncedItems {
  final ConnectionHandler connectionHandler;

  GetSyncedItemsImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    String machineId,
    int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, String> params = {};

    if (machineId != null) {
      params['machine_id'] = machineId;
    }
    if (userId != null) {
      params['user_id'] = userId.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_synced_items',
      params: params,
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
