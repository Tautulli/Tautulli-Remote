import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/synced_item.dart';
import '../../domain/repositories/synced_items_repository.dart';
import '../datasources/synced_items_data_source.dart';

class SyncedItemsRepositoryImpl implements SyncedItemsRepository {
  final SyncedItemsDataSource dataSource;
  final NetworkInfo networkInfo;

  SyncedItemsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SyncedItem>>> getSyncedItems({
    @required String tautulliId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final syncedItemsList = await dataSource.getSyncedItems(
          tautulliId: tautulliId,
        );
        return Right(syncedItemsList);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
