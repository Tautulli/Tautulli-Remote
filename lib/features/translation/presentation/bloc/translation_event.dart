part of 'translation_bloc.dart';

abstract class TranslationEvent extends Equatable {
  const TranslationEvent();

  @override
  List<Object> get props => [];
}

class TranslationLocaleUpdated extends TranslationEvent {
  final Locale locale;

  const TranslationLocaleUpdated(this.locale);
}
