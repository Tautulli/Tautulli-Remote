part of 'onesignal_status_bloc.dart';

abstract class OneSignalStatusState extends Equatable {
  const OneSignalStatusState();

  @override
  List<Object> get props => [];
}

class OneSignalStatusInitial extends OneSignalStatusState {}

class OneSignalStatusInProgress extends OneSignalStatusState {}

class OneSignalStatusSuccess extends OneSignalStatusState {
  final bool hasNotificationPermission;
  final bool isPushDisabled;
  final bool isSubscribed;
  final String userId;

  const OneSignalStatusSuccess({
    required this.hasNotificationPermission,
    required this.isPushDisabled,
    required this.isSubscribed,
    required this.userId,
  });

  @override
  List<Object> get props => [hasNotificationPermission, isPushDisabled, isSubscribed, userId];
}

class OneSignalStatusFailure extends OneSignalStatusState {}
