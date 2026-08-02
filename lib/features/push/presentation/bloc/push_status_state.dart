part of 'push_status_bloc.dart';

abstract class PushStatusState extends Equatable {
  const PushStatusState();

  @override
  List<Object> get props => [];
}

class PushStatusInitial extends PushStatusState {}

class PushStatusInProgress extends PushStatusState {}

class PushStatusSuccess extends PushStatusState {
  final bool hasNotificationPermission;
  final bool isOptedIn;
  final bool isSubscribed;
  final String token;
  final PushLimits limits;
  final PushUsage usage;

  const PushStatusSuccess({
    required this.hasNotificationPermission,
    required this.isOptedIn,
    required this.isSubscribed,
    required this.token,
    required this.limits,
    required this.usage,
  });

  @override
  List<Object> get props => [hasNotificationPermission, isOptedIn, isSubscribed, token, limits, usage];
}

class PushStatusFailure extends PushStatusState {}
