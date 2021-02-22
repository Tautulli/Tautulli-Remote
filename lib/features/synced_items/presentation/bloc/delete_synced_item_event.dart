part of 'delete_synced_item_bloc.dart';

abstract class DeleteSyncedItemEvent extends Equatable {
  const DeleteSyncedItemEvent();
}

class DeleteSyncedItemStarted extends DeleteSyncedItemEvent {
  final String tautulliId;
  final String clientId;
  final int syncId;
  final SlidableState slidableState;

  DeleteSyncedItemStarted({
    @required this.tautulliId,
    @required this.clientId,
    @required this.syncId,
    this.slidableState,
  });

  @override
  List<Object> get props => [tautulliId, clientId, syncId, slidableState];
}
