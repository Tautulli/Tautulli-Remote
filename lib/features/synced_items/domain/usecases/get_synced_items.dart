import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/synced_item.dart';
import '../repositories/synced_items_repository.dart';

class GetSyncedItems {
  final SyncedItemsRepository repository;

  GetSyncedItems({@required this.repository});

  Future<Either<Failure, List<SyncedItem>>> call({
    @required String tautulliId,
  }) async {
    return await repository.getSyncedItems(tautulliId: tautulliId);
  }
}
