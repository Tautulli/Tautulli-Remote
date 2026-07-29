part of 'push_status_bloc.dart';

abstract class PushStatusEvent extends Equatable {
  const PushStatusEvent();

  @override
  List<Object> get props => [];
}

class PushStatusLoad extends PushStatusEvent {}
