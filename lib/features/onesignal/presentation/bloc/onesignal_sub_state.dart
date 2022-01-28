part of 'onesignal_sub_bloc.dart';

abstract class OneSignalSubState extends Equatable {
  const OneSignalSubState();

  @override
  List<Object> get props => [];
}

class OneSignalSubInitial extends OneSignalSubState {}

class OneSignalSubSuccess extends OneSignalSubState {}

class OneSignalSubFailure extends OneSignalSubState {
  final String title;
  final String message;

  const OneSignalSubFailure({
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [title, message];
}
