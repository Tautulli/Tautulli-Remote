import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/push_status.dart';
import '../../domain/usecases/push.dart';

part 'push_sub_event.dart';
part 'push_sub_state.dart';

class PushSubBloc extends Bloc<PushSubEvent, PushSubState> {
  final Logging logging;
  final Push push;

  PushSubBloc({
    required this.logging,
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
      logging.info('Notifications :: This device is registered to receive notifications');

      emit(
        PushSubSuccess(),
      );
    } else if (!isSubscribed) {
      logging.warning(
        'Notifications :: This device is not registered to receive notifications, '
        'notification permission or consent may be missing',
      );

      emit(
        PushSubFailure(
          title: LocaleKeys.notifications_error_registration_title.tr(),
          message: LocaleKeys.notifications_error_registration_message.tr(),
        ),
      );
    } else {
      logging.error('Notifications :: Subscribed but no usable push token was returned');

      emit(
        PushSubFailure(
          title: LocaleKeys.notifications_error_unexpected_title.tr(),
          message: LocaleKeys.notifications_error_unexpected_message.tr(),
        ),
      );
    }
  }
}
