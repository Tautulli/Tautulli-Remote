part of 'translation_bloc.dart';

abstract class TranslationState extends Equatable {
  const TranslationState();  

  @override
  List<Object> get props => [];
}
class TranslationInitial extends TranslationState {}
