part of 'onesignal_health_bloc.dart';

@immutable
abstract class OneSignalHealthEvent extends Equatable {
  const OneSignalHealthEvent();
}

class OneSignalHealthCheck extends OneSignalHealthEvent {
  @override
  List<Object> get props => [];
}
