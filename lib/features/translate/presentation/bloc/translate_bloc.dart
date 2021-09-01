// @dart=2.9

import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/helpers/translation_helper.dart';
import '../../../logging/domain/usecases/logging.dart';

part 'translate_event.dart';
part 'translate_state.dart';

class TranslateBloc extends Bloc<TranslateEvent, TranslateState> {
  final Logging logging;

  TranslateBloc({@required this.logging}) : super(TranslateInitial());

  @override
  Stream<TranslateState> mapEventToState(
    TranslateEvent event,
  ) async* {
    if (event is TranslateUpdate) {
      logging.info(
        'Settings: Language changed to ${TranslationHelper.localeToString(event.locale)}',
      );
    }
  }
}
