// @dart=2.9

part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {
  final Map<String, Map<String, dynamic>> activityMap;

  ActivityInitial({
    @required this.activityMap,
  });

  @override
  List<Object> get props => [activityMap];
}

class ActivityLoaded extends ActivityState {
  final Map<String, Map<String, dynamic>> activityMap;
  final DateTime loadedAt;

  ActivityLoaded({
    @required this.activityMap,
    @required this.loadedAt,
  })  : assert(activityMap != null),
        assert(loadedAt != null);

  @override
  List<Object> get props => [activityMap, loadedAt];
}

class ActivityLoadFailure extends ActivityState {
  final Failure failure;
  final String message;
  final String suggestion;

  ActivityLoadFailure({
    @required this.failure,
    @required this.message,
    this.suggestion,
  });

  @override
  List<Object> get props => [message, suggestion];
}
