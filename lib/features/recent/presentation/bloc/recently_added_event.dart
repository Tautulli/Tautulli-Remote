part of 'recently_added_bloc.dart';

abstract class RecentlyAddedEvent extends Equatable {
  const RecentlyAddedEvent();
}

class RecentlyAddedFetched extends RecentlyAddedEvent {
  final String tautulliId;

  RecentlyAddedFetched({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}

class RecentlyAddedLoadNewServer extends RecentlyAddedEvent {
  final String tautulliId;

  RecentlyAddedLoadNewServer({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}