part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
}

class ActivityEmpty extends ActivityState {
  @override
  List<Object> get props => [];
}

class ActivityLoadInProgress extends ActivityState {
  @override
  List<Object> get props => [];
}

/// A state to indicate fetching activity from the server was successful.
/// 
/// Takes a [DateTime] value to ensure this state is always unique.
class ActivityLoadSuccess extends ActivityState {
  final List<ActivityItem> activity;
  final Map<String, dynamic> geoIpMap;
  final TautulliApiUrls tautulliApiUrls;
  final DateTime loadedAt;

  ActivityLoadSuccess({
    @required this.activity,
    @required this.geoIpMap,
    @required this.tautulliApiUrls,
    @required this.loadedAt,
  })  : assert(activity != null),
        assert(tautulliApiUrls != null),
        assert(loadedAt != null);

  @override
  List<Object> get props => [activity, geoIpMap, tautulliApiUrls, loadedAt];
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
