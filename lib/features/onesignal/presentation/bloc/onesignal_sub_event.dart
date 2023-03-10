part of 'onesignal_sub_bloc.dart';

abstract class OneSignalSubEvent extends Equatable {
  const OneSignalSubEvent();

  @override
  List<Object> get props => [];
}

class OneSignalSubCheck extends OneSignalSubEvent {}
