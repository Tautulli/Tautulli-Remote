import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class DeleteSyncedItem {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
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
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'delete_synced_item',
      params: {
        'client_id': clientId,
        'sync_id': syncId.toString(),
      },
    );

    return responseJson;
  }
}
