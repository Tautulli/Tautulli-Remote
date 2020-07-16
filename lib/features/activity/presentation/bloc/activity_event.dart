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
