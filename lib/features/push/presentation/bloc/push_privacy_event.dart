part of 'push_privacy_bloc.dart';

abstract class PushPrivacyEvent extends Equatable {
  const PushPrivacyEvent();

  @override
  List<Object> get props => [];
}

class PushPrivacyCheck extends PushPrivacyEvent {}

class PushPrivacyGrant extends PushPrivacyEvent {}

class PushPrivacyRevoke extends PushPrivacyEvent {}
