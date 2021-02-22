import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../domain/entities/synced_item.dart';
import '../models/synced_item_model.dart';

abstract class SyncedItemsDataSource {
  Future<List> getSyncedItems({
    @required String tautulliId,
    int userId,
  });
}

class SyncedItemsDataSourceImpl implements SyncedItemsDataSource {
  final tautulliApi.GetSyncedItems apiGetSyncedItems;

  SyncedItemsDataSourceImpl({@required this.apiGetSyncedItems});

  @override
  Future<List> getSyncedItems({
    String tautulliId,
    int userId,
  }) async {
    final syncedItemsJson = await apiGetSyncedItems(
      tautulliId: tautulliId,
      userId: userId,
    );

    final List<SyncedItem> syncedItemsList = [];
    syncedItemsJson['response']['data'].forEach((item) {
      syncedItemsList.add(SyncedItemModel.fromJson(item));
    });

    return syncedItemsList;
  }
}
