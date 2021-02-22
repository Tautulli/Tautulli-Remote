import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meta/meta.dart';
import '../../../../core/error/failure.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/usecases/delete_synced_item.dart';

part 'delete_synced_item_event.dart';
part 'delete_synced_item_state.dart';

class DeleteSyncedItemBloc
    extends Bloc<DeleteSyncedItemEvent, DeleteSyncedItemState> {
  final DeleteSyncedItem deleteSyncedItem;
  final Logging logging;

  DeleteSyncedItemBloc({
    @required this.deleteSyncedItem,
    @required this.logging,
  }) : super(DeleteSyncedItemInitial());

  @override
  Stream<DeleteSyncedItemState> mapEventToState(
    DeleteSyncedItemEvent event,
  ) async* {
    if (event is DeleteSyncedItemStarted) {
      yield DeleteSyncedItemInProgress(
        syncId: event.syncId,
      );

      final failureOrTerminateStream = await deleteSyncedItem(
        tautulliId: event.tautulliId,
        clientId: event.clientId,
        syncId: event.syncId,
      );

      yield* failureOrTerminateStream.fold(
        (failure) async* {
          logging.error(
            'TerminateStream: Failed to delete synced item: ${event.syncId}',
          );

          yield DeleteSyncedItemFailure(
            failure: failure,
          );
        },
        (success) async* {
          yield DeleteSyncedItemSuccess(
            slidableState: event.slidableState,
          );
        },
      );
    }
  }
}
