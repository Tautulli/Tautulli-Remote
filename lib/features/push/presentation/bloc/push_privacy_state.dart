part of 'push_privacy_bloc.dart';

abstract class PushPrivacyState extends Equatable {
  const PushPrivacyState();

  @override
  List<Object> get props => [];
}

class PushPrivacyInitial extends PushPrivacyState {}

class PushPrivacySuccess extends PushPrivacyState {}

class PushPrivacyFailure extends PushPrivacyState {}
