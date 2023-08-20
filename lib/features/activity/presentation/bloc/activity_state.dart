part of 'activity_bloc.dart';

class ActivityState extends Equatable {
  final List<ServerActivityModel> serverActivityList;
  final bool freshFetch;

  const ActivityState({
    this.serverActivityList = const [],
    required this.freshFetch,
  });

  ActivityState copyWith({
    List<ServerActivityModel>? serverActivityList,
    bool? freshFetch,
  }) {
    return ActivityState(
      serverActivityList: serverActivityList ?? this.serverActivityList,
      freshFetch: freshFetch ?? this.freshFetch,
    );
  }

  @override
  List<Object> get props => [serverActivityList, freshFetch];
}
