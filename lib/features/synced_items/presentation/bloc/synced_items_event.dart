part of 'synced_items_bloc.dart';

abstract class SyncedItemsEvent extends Equatable {
  const SyncedItemsEvent();

  @override
  List<Object> get props => [];
}

class SyncedItemsFetch extends SyncedItemsEvent {
  final String tautulliId;

  SyncedItemsFetch({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}

class SyncedItemsFilter extends SyncedItemsEvent {
  final String tautulliId;

  SyncedItemsFilter({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}
