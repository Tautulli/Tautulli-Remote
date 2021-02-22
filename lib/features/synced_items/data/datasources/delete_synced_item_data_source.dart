import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;

abstract class DeleteSyncedItemDataSource {
  Future<bool> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
  });
}

class DeleteSyncedItemDataSourceImpl implements DeleteSyncedItemDataSource {
  final tautulliApi.DeleteSyncedItem apiDeleteSyncedItem;

  DeleteSyncedItemDataSourceImpl({@required this.apiDeleteSyncedItem});

  @override
  Future<bool> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
  }) async {
    final deleteSyncedItemJson = await apiDeleteSyncedItem(
      tautulliId: tautulliId,
      clientId: clientId,
      syncId: syncId,
    );

    if (deleteSyncedItemJson['response']['result'] == 'success') {
      return true;
    }

    return false;
  }
}
