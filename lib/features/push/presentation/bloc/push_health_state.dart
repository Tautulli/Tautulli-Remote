part of 'push_health_bloc.dart';

abstract class PushHealthState extends Equatable {
  const PushHealthState();

  @override
  List<Object> get props => [];
}

class PushHealthInitial extends PushHealthState {}

class PushHealthInProgress extends PushHealthState {}

class PushHealthSuccess extends PushHealthState {}

class PushHealthFailure extends PushHealthState {}
