part of 'synced_items_bloc.dart';

abstract class SyncedItemsEvent extends Equatable {
  const SyncedItemsEvent();

  @override
  List<Object> get props => [];
}

class SyncedItemsFetch extends SyncedItemsEvent {
  final String tautulliId;
  final int userId;
  final SettingsBloc settingsBloc;

  SyncedItemsFetch({
    @required this.tautulliId,
    this.userId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, userId, settingsBloc];
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
