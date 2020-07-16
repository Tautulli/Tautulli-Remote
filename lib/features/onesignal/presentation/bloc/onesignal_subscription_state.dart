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

  OneSignalSubscriptionFailure({
    @required this.title,
    @required this.message,
  });

  @override
  List<Object> get props => [title, message];
}
