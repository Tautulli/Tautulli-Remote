import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class DeleteSyncedItem {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
    @required SettingsBloc settingsBloc,
  });
}

class DeleteSyncedItemImpl implements DeleteSyncedItem {
  final ConnectionHandler connectionHandler;

  DeleteSyncedItemImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'delete_synced_item',
      params: {
        'client_id': clientId,
        'sync_id': syncId.toString(),
      },
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
