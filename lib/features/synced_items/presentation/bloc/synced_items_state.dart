part of 'synced_items_bloc.dart';

abstract class SyncedItemsState extends Equatable {
  const SyncedItemsState();

  @override
  List<Object> get props => [];
}

class SyncedItemsInitial extends SyncedItemsState {
  final int userId;
  final String tautulliId;

  SyncedItemsInitial({
    this.userId,
    this.tautulliId,
  });

  @override
  List<Object> get props => [userId, tautulliId];
}

class SyncedItemsSuccess extends SyncedItemsState {
  final List<SyncedItem> list;

  SyncedItemsSuccess({@required this.list});

  @override
  List<Object> get props => [list];
}

class SyncedItemsFailure extends SyncedItemsState {
  final Failure failure;
  final String message;
  final String suggestion;

  SyncedItemsFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
