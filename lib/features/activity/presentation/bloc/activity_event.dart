part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
}

class ActivityLoad extends ActivityEvent {
  @override
  List<Object> get props => [];
}

class ActivityRefresh extends ActivityEvent {
  @override
  List<Object> get props => [];
}

class ActivityRemove extends ActivityEvent {
  final Map<String, Map<String, Object>> activityMap;
  final String tautulliId;
  final String sessionId;

  ActivityRemove({
    @required this.activityMap,
    @required this.tautulliId,
    @required this.sessionId,
  });

  @override
  List<Object> get props => [activityMap, tautulliId, sessionId];
}
