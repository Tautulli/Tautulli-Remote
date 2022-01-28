part of 'onesignal_status_bloc.dart';

abstract class OneSignalStatusState extends Equatable {
  const OneSignalStatusState();

  @override
  List<Object> get props => [];
}

class OneSignalStatusInitial extends OneSignalStatusState {}

class OneSignalStatusInProgress extends OneSignalStatusState {}

class OneSignalStatusSuccess extends OneSignalStatusState {
  final OSDeviceState state;

  const OneSignalStatusSuccess({required this.state});

  @override
  List<Object> get props => [state];
}

class OneSignalStatusFailure extends OneSignalStatusState {}
