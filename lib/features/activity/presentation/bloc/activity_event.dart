part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class ActivityFetched extends ActivityEvent {
  final String tautulliId;
  final int? sessionKey;
  final String? sessionId;
  final SettingsBloc settingsBloc;
  final bool freshFetch;

  const ActivityFetched({
    required this.tautulliId,
    this.sessionKey,
    this.sessionId,
    required this.settingsBloc,
    this.freshFetch = false,
  });

  @override
  List<Object> get props => [tautulliId, settingsBloc, freshFetch];
}
