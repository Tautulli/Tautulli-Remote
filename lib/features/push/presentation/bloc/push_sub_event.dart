part of 'push_sub_bloc.dart';

abstract class PushSubEvent extends Equatable {
  const PushSubEvent();

  @override
  List<Object> get props => [];
}

class PushSubCheck extends PushSubEvent {}
