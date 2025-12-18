part of 'activity_bloc.dart';

class ActivityState extends Equatable {
  final List<ServerActivityModel> serverActivityList;
  final bool freshFetch;
  final DateTime lastAutoRefresh;

  const ActivityState({
    this.serverActivityList = const [],
    required this.freshFetch,
    required this.lastAutoRefresh,
  });

  ActivityState copyWith({
    List<ServerActivityModel>? serverActivityList,
    bool? freshFetch,
    DateTime? lastAutoRefresh,
  }) {
    return ActivityState(
      serverActivityList: serverActivityList ?? this.serverActivityList,
      freshFetch: freshFetch ?? this.freshFetch,
      lastAutoRefresh: lastAutoRefresh ?? this.lastAutoRefresh,
    );
  }

  @override
  List<Object> get props => [serverActivityList, freshFetch];
}
