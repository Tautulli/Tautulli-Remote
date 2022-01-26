import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../settings/domain/usecases/settings.dart';
import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_privacy_event.dart';
part 'onesignal_privacy_state.dart';

class OneSignalPrivacyBloc
    extends Bloc<OneSignalPrivacyEvent, OneSignalPrivacyState> {
  final OneSignalDataSource oneSignal;
  final Settings settings;

  OneSignalPrivacyBloc({
    required this.oneSignal,
    required this.settings,
  }) : super(OneSignalPrivacyInitial()) {
    on<OneSignalPrivacyCheck>(
      (event, emit) => _onOneSignalPrivacyCheck(event, emit),
    );
    on<OneSignalPrivacyGrant>(
      (event, emit) => _onOneSignalPrivacyGrant(event, emit),
    );
    on<OneSignalPrivacyRevoke>(
      (event, emit) => _onOneSignalPrivacyRevoke(event, emit),
    );
  }

  void _onOneSignalPrivacyCheck(
    OneSignalPrivacyCheck event,
    Emitter<OneSignalPrivacyState> emit,
  ) async {
    if (await oneSignal.hasConsented) {
      print('CONSENTED');
      emit(
        OneSignalPrivacySuccess(),
      );
    } else {
      print('NOT CONSENTED');
      emit(
        OneSignalPrivacyFailure(),
      );
    }
  }

  void _onOneSignalPrivacyGrant(
    OneSignalPrivacyGrant event,
    Emitter<OneSignalPrivacyState> emit,
  ) async {}

  void _onOneSignalPrivacyRevoke(
    OneSignalPrivacyRevoke event,
    Emitter<OneSignalPrivacyState> emit,
  ) async {}
}
