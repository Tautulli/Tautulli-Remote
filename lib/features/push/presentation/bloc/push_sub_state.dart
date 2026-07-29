part of 'push_sub_bloc.dart';

abstract class PushSubState extends Equatable {
  const PushSubState();

  @override
  List<Object> get props => [];
}

class PushSubInitial extends PushSubState {}

class PushSubSuccess extends PushSubState {}

class PushSubFailure extends PushSubState {
  final String title;
  final String message;

  const PushSubFailure({
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [title, message];
}
