// @dart=2.9

part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class ActivityLoadAndRefresh extends ActivityEvent {
  final SettingsBloc settingsBloc;

  ActivityLoadAndRefresh({@required this.settingsBloc});

  @override
  List<Object> get props => [settingsBloc];
}

class ActivityLoadServer extends ActivityEvent {
  final String tautulliId;
  final String plexName;
  final Either<Failure, List<ActivityItem>> failureOrActivity;

  ActivityLoadServer({
    @required this.tautulliId,
    @required this.plexName,
    @required this.failureOrActivity,
  });

  @override
  List<Object> get props => [tautulliId, plexName, failureOrActivity];
}

class ActivityAutoRefreshStart extends ActivityEvent {}

class ActivityAutoRefreshStop extends ActivityEvent {}
