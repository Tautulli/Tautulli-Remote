part of 'onesignal_health_bloc.dart';

abstract class OneSignalHealthState extends Equatable {
  const OneSignalHealthState();

  @override
  List<Object> get props => [];
}

class OneSignalHealthInitial extends OneSignalHealthState {}

class OneSignalHealthInProgress extends OneSignalHealthState {}

class OneSignalHealthSuccess extends OneSignalHealthState {}

class OneSignalHealthFailure extends OneSignalHealthState {}
