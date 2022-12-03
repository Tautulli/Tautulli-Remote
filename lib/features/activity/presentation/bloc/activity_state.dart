part of 'activity_bloc.dart';

class ActivityState extends Equatable {
  final BlocStatus status;
  final List<ServerActivityModel> serverActivityList;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const ActivityState({
    this.status = BlocStatus.initial,
    this.serverActivityList = const [],
    this.failure,
    this.message,
    this.suggestion,
  });

  ActivityState copyWith({
    BlocStatus? status,
    List<ServerActivityModel>? serverActivityList,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return ActivityState(
      status: status ?? this.status,
      serverActivityList: serverActivityList ?? this.serverActivityList,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [status, serverActivityList];
}
