import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/delete_synced_item_repository.dart';
import '../datasources/delete_synced_item_data_source.dart';

class DeleteSyncedItemRepositoryImpl implements DeleteSyncedItemRepository {
  final DeleteSyncedItemDataSource dataSource;
  final NetworkInfo networkInfo;

  DeleteSyncedItemRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource(
          tautulliId: tautulliId,
          clientId: clientId,
          syncId: syncId,
        );

        if (result) {
          return Right(result);
        } else {
          return Left(DeleteSyncedFailure());
        }
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
