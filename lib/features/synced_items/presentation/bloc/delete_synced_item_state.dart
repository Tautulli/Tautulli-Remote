// @dart=2.9

part of 'delete_synced_item_bloc.dart';

abstract class DeleteSyncedItemState extends Equatable {
  const DeleteSyncedItemState();

  @override
  List<Object> get props => [];
}

class DeleteSyncedItemInitial extends DeleteSyncedItemState {}

class DeleteSyncedItemInProgress extends DeleteSyncedItemState {
  final int syncId;

  DeleteSyncedItemInProgress({
    @required this.syncId,
  });

  @override
  List<Object> get props => [syncId];
}

class DeleteSyncedItemSuccess extends DeleteSyncedItemState {
  final SlidableState slidableState;

  DeleteSyncedItemSuccess({this.slidableState});

  @override
  List<Object> get props => [slidableState];
}

class DeleteSyncedItemFailure extends DeleteSyncedItemState {
  final Failure failure;

  DeleteSyncedItemFailure({@required this.failure});

  @override
  List<Object> get props => [failure];
}
