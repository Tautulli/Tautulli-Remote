part of 'push_health_bloc.dart';

abstract class PushHealthEvent extends Equatable {
  const PushHealthEvent();

  @override
  List<Object> get props => [];
}

class PushHealthCheck extends PushHealthEvent {}
