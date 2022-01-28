import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/helpers/translation_helper.dart';
import '../../../logging/domain/usecases/logging.dart';

part 'translation_event.dart';
part 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final Logging logging;

  TranslationBloc({
    required this.logging,
  }) : super(TranslationInitial()) {
    on<TranslationLocaleUpdated>(
      (event, emit) => _translationLocaleUpdated(event, emit),
    );
  }

  void _translationLocaleUpdated(
    TranslationLocaleUpdated event,
    Emitter<TranslationState> emit,
  ) {
    logging.info(
      'Settings :: Locale changed to ${TranslationHelper.localeToEnglishString(event.locale)} [code: ${event.locale}]',
    );
  }
}
