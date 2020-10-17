import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../domain/entities/synced_item.dart';
import '../models/synced_item_model.dart';

abstract class SyncedItemsDataSource {
  Future<List> getSyncedItems({
    @required String tautulliId,
  });
}

class SyncedItemsDataSourceImpl implements SyncedItemsDataSource {
  final TautulliApi tautulliApi;

  SyncedItemsDataSourceImpl({@required this.tautulliApi});

  @override
  Future<List> getSyncedItems({
    String tautulliId,
  }) async {
    final syncedItemsJson =
        await tautulliApi.getSyncedItems(tautulliId: tautulliId);
    
    final List<SyncedItem> syncedItemsList = [];
    syncedItemsJson['response']['data'].forEach((item) {
      syncedItemsList.add(SyncedItemModel.fromJson(item));
    });

    return syncedItemsList;
  }
}
