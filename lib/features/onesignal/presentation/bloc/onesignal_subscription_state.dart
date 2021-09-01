// @dart=2.9

part of 'onesignal_subscription_bloc.dart';

abstract class OneSignalSubscriptionState extends Equatable {
  const OneSignalSubscriptionState();
}

class OneSignalSubscriptionInitial extends OneSignalSubscriptionState {
  @override
  List<Object> get props => [];
}

class OneSignalSubscriptionSuccess extends OneSignalSubscriptionState {
  @override
  List<Object> get props => [];
}

class OneSignalSubscriptionFailure extends OneSignalSubscriptionState {
  final String title;
  final String message;
  final bool consented;

  OneSignalSubscriptionFailure({
    @required this.title,
    @required this.message,
    @required this.consented,
  });

  @override
  List<Object> get props => [title, message];
}
