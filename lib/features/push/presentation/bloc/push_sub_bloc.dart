import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../data/datasources/push_data_source.dart';
import '../../domain/usecases/push.dart';

part 'push_sub_event.dart';
part 'push_sub_state.dart';

class PushSubBloc extends Bloc<PushSubEvent, PushSubState> {
  final Push push;

  PushSubBloc({
    required this.push,
  }) : super(PushSubInitial()) {
    on<PushSubCheck>(
      (event, emit) => _onPushSubCheck(event, emit),
    );
  }

  void _onPushSubCheck(
    PushSubCheck event,
    Emitter<PushSubState> emit,
  ) async {
    final bool isSubscribed = await push.isSubscribed;
    final String token = await push.token;

    if (isSubscribed && isNotBlank(token) && token != pushDisabled) {
      emit(
        PushSubSuccess(),
      );
    } else if (!isSubscribed) {
      emit(
        PushSubFailure(
          title: LocaleKeys.notifications_error_registration_title.tr(),
          message: LocaleKeys.notifications_error_registration_message.tr(),
        ),
      );
    } else {
      emit(
        PushSubFailure(
          title: LocaleKeys.notifications_error_unexpected_title.tr(),
          message: LocaleKeys.notifications_error_unexpected_message.tr(),
        ),
      );
    }
  }
}
