// @dart=2.9

part of 'translate_bloc.dart';

abstract class TranslateState extends Equatable {
  const TranslateState();

  @override
  List<Object> get props => [];
}

class TranslateInitial extends TranslateState {}
