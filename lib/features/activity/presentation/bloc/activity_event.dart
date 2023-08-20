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
  final SettingsBloc settingsBloc;

  const ActivityFetched({
    required this.serverList,
    required this.multiserver,
    required this.activeServerId,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [serverList, activeServerId, multiserver, settingsBloc];
}

class ActivityLoadServer extends ActivityEvent {
  final String tautulliId;
  final String serverName;
  final Either<Failure, Tuple2<List<ActivityModel>, bool>> failureOrActivity;
  final SettingsBloc settingsBloc;

  const ActivityLoadServer({
    required this.tautulliId,
    required this.serverName,
    required this.failureOrActivity,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, serverName, failureOrActivity, settingsBloc];
}

class ActivityAutoRefreshStart extends ActivityEvent {}

class ActivityAutoRefreshStop extends ActivityEvent {}
