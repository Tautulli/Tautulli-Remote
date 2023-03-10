import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_sub_event.dart';
part 'onesignal_sub_state.dart';

String registerErrorTitle = LocaleKeys.onesignal_error_registration_title.tr();
String registerErrorMessage =
    LocaleKeys.onesignal_error_registration_message.tr();
String unexpectedErrorTitle = LocaleKeys.onesignal_error_unexpected_title.tr();
String unexpectedErrorMessage =
    LocaleKeys.onesignal_error_unexpected_message.tr();

class OneSignalSubBloc extends Bloc<OneSignalSubEvent, OneSignalSubState> {
  final OneSignalDataSource oneSignal;

  OneSignalSubBloc({
    required this.oneSignal,
  }) : super(OneSignalSubInitial()) {
    on<OneSignalSubCheck>(
      (event, emit) => _onOneSignalSubCheck(event, emit),
    );
  }

  void _onOneSignalSubCheck(
    OneSignalSubCheck event,
    Emitter<OneSignalSubState> emit,
  ) async {
    final bool isSubscribed = await oneSignal.isSubscribed;
    final String userId = await oneSignal.userId;

    if (isSubscribed && isNotBlank(userId)) {
      emit(
        OneSignalSubSuccess(),
      );
    } else if (!isSubscribed) {
      emit(
        OneSignalSubFailure(
          title: registerErrorTitle,
          message: registerErrorMessage,
        ),
      );
    } else {
      emit(
        OneSignalSubFailure(
          title: unexpectedErrorTitle,
          message: unexpectedErrorMessage,
        ),
      );
    }
  }
}
