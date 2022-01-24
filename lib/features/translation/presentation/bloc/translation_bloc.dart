import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'translation_event.dart';
part 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  TranslationBloc() : super(TranslationInitial()) {
    on<TranslationLocaleUpdated>(
      (event, emit) => _translationLocaleUpdated(event, emit),
    );
  }

  void _translationLocaleUpdated(
    TranslationLocaleUpdated event,
    Emitter<TranslationState> emit,
  ) {
    //TODO Add logging when locale is changed
  }
}
