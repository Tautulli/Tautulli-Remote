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
  final Map<String, Map<String, Object>> activityMap;
  final Map<String, dynamic> geoIpMap;
  final TautulliApiUrls tautulliApiUrls;
  final DateTime loadedAt;

  ActivityLoadSuccess({
    @required this.activityMap,
    @required this.geoIpMap,
    @required this.tautulliApiUrls,
    @required this.loadedAt,
  })  : assert(activityMap != null),
        assert(tautulliApiUrls != null),
        assert(loadedAt != null);

  @override
  List<Object> get props => [activityMap, geoIpMap, tautulliApiUrls, loadedAt];
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
