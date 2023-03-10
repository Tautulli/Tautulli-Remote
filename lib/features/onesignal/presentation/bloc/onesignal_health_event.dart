part of 'onesignal_health_bloc.dart';

abstract class OneSignalHealthEvent extends Equatable {
  const OneSignalHealthEvent();

  @override
  List<Object> get props => [];
}

class OneSignalHealthCheck extends OneSignalHealthEvent {}
