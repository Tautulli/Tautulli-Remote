part of 'activity_bloc.dart';

class ActivityState extends Equatable {
  final List<ServerActivityModel> serverActivityList;

  const ActivityState({
    this.serverActivityList = const [],
  });

  ActivityState copyWith({
    List<ServerActivityModel>? serverActivityList,
  }) {
    return ActivityState(
      serverActivityList: serverActivityList ?? this.serverActivityList,
    );
  }

  @override
  List<Object> get props => [serverActivityList];
}
