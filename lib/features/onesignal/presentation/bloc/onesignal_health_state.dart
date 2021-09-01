// @dart=2.9

part of 'onesignal_health_bloc.dart';

@immutable
abstract class OneSignalHealthState extends Equatable {}

class OneSignalHealthInitial extends OneSignalHealthState {
  @override
  List<Object> get props => [];
}

class OneSignalHealthInProgress extends OneSignalHealthState {
  @override
  List<Object> get props => [];
}

class OneSignalHealthSuccess extends OneSignalHealthState {
  @override
  List<Object> get props => [];
}

class OneSignalHealthFailure extends OneSignalHealthState {
  @override
  List<Object> get props => [];
}
