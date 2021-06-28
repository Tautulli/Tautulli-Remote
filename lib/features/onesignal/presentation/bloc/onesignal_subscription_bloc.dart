import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_subscription_event.dart';
part 'onesignal_subscription_state.dart';

String CONSENT_ERROR_TITLE = LocaleKeys.onesignal_consent_error_title.tr();
String CONSENT_ERROR_MESSAGE = LocaleKeys.onesignal_consent_error_message.tr();
String REGISTER_ERROR_TITLE = LocaleKeys.onesignal_register_error_title.tr();
String REGISTER_ERROR_MESSAGE =
    LocaleKeys.onesignal_register_error_message.tr();
String UNEXPECTED_ERROR_TITLE =
    LocaleKeys.onesignal_unexpected_error_title.tr();
String UNEXPECTED_ERROR_MESSAGE =
    LocaleKeys.onesignal_unexpected_error_message.tr();

class OneSignalSubscriptionBloc
    extends Bloc<OneSignalSubscriptionEvent, OneSignalSubscriptionState> {
  final OneSignalDataSource oneSignal;

  OneSignalSubscriptionBloc({@required this.oneSignal})
      : super(OneSignalSubscriptionInitial());

  @override
  Stream<OneSignalSubscriptionState> mapEventToState(
    OneSignalSubscriptionEvent event,
  ) async* {
    if (event is OneSignalSubscriptionCheck) {
      final bool hasConsented = await oneSignal.hasConsented;
      final bool isSubscribed = await oneSignal.isSubscribed;
      final String userId = await oneSignal.userId;

      if (hasConsented == true && isSubscribed == true && isNotEmpty(userId)) {
        yield OneSignalSubscriptionSuccess();
      } else if (hasConsented == false) {
        yield OneSignalSubscriptionFailure(
          title: CONSENT_ERROR_TITLE,
          message: CONSENT_ERROR_MESSAGE,
          consented: false,
        );
      } else if (isSubscribed == false || userId == null) {
        yield OneSignalSubscriptionFailure(
          title: REGISTER_ERROR_TITLE,
          message: REGISTER_ERROR_MESSAGE,
          consented: true,
        );
      } else {
        yield OneSignalSubscriptionFailure(
          title: UNEXPECTED_ERROR_TITLE,
          message: UNEXPECTED_ERROR_MESSAGE,
          consented: true,
        );
      }
    }
  }
}
