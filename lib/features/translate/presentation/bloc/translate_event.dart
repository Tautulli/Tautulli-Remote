part of 'translate_bloc.dart';

abstract class TranslateEvent extends Equatable {
  const TranslateEvent();

  @override
  List<Object> get props => [];
}

class TranslateUpdate extends TranslateEvent {
  final Locale locale;

  TranslateUpdate({
    @required this.locale,
  });
}
