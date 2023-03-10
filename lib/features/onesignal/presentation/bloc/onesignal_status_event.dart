part of 'onesignal_status_bloc.dart';

abstract class OneSignalStatusEvent extends Equatable {
  const OneSignalStatusEvent();

  @override
  List<Object> get props => [];
}

class OneSignalStatusLoad extends OneSignalStatusEvent {}
