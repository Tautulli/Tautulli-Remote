part of 'onesignal_subscription_bloc.dart';

abstract class OneSignalSubscriptionEvent extends Equatable {
  const OneSignalSubscriptionEvent();
}

class OneSignalSubscriptionCheck extends OneSignalSubscriptionEvent {
  @override
  List<Object> get props => [];
}
