part of 'synced_items_bloc.dart';

abstract class SyncedItemsEvent extends Equatable {
  const SyncedItemsEvent();

  @override
  List<Object> get props => [];
}

class SyncedItemsFetch extends SyncedItemsEvent {
  final String tautulliId;
  final int userId;

  SyncedItemsFetch({
    @required this.tautulliId,
    this.userId,
  });

  @override
  List<Object> get props => [tautulliId, userId];
}

class SyncedItemsFilter extends SyncedItemsEvent {
  final String tautulliId;
  final int userId;

  SyncedItemsFilter({
    @required this.tautulliId,
    this.userId,
  });

  @override
  List<Object> get props => [tautulliId, userId];
}
