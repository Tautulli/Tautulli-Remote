part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

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
