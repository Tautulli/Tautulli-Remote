part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class ActivityFetched extends ActivityEvent {
  final List<ServerModel> serverList;
  final bool multiserver;
  final String activeServerId;
  final bool freshFetch;
  final bool autoRefresh;

  const ActivityFetched({
    required this.serverList,
    required this.multiserver,
    required this.activeServerId,
    this.freshFetch = false,
    this.autoRefresh = false,
  });

  @override
  List<Object> get props => [serverList, activeServerId, multiserver, autoRefresh];
}

class ActivityLoadServer extends ActivityEvent {
  final String tautulliId;
  final String serverName;
  final Either<Failure, Tuple2<List<ActivityModel>, bool>> failureOrActivity;

  const ActivityLoadServer({
    required this.tautulliId,
    required this.serverName,
    required this.failureOrActivity,
  });

  @override
  List<Object> get props => [tautulliId, serverName, failureOrActivity];
}

class ActivityAutoRefreshStart extends ActivityEvent {}

class ActivityAutoRefreshStop extends ActivityEvent {}
