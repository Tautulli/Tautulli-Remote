part of 'push_privacy_bloc.dart';

abstract class PushPrivacyState extends Equatable {
  const PushPrivacyState();

  /// Whether consent has settled on a value. Await this rather than a specific
  /// state: bloc drops an emission equal to the current state, so a grant that
  /// fails from [PushPrivacyFailure] is only observable because
  /// [PushPrivacyInProgress] came between them.
  bool get isSettled => this is PushPrivacySuccess || this is PushPrivacyFailure;

  @override
  List<Object> get props => [];
}

class PushPrivacyInitial extends PushPrivacyState {}

/// A grant or revoke is running. Emitted before the work starts.
class PushPrivacyInProgress extends PushPrivacyState {}

class PushPrivacySuccess extends PushPrivacyState {}

class PushPrivacyFailure extends PushPrivacyState {}
