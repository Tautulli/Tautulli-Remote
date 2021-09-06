// @dart=2.9

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../../../settings/domain/usecases/settings.dart';

part 'wizard_event.dart';
part 'wizard_state.dart';

enum WizardStage {
  servers,
  oneSignal,
  closing,
}

WizardStage currentWizardStage = WizardStage.servers;

class WizardBloc extends Bloc<WizardEvent, WizardState> {
  WizardBloc()
      : super(
          WizardLoaded(
            wizardStage: WizardStage.servers,
          ),
        );

  @override
  Stream<WizardState> mapEventToState(
    WizardEvent event,
  ) async* {
    final currentState = state;

    if (currentState is WizardLoaded) {
      if (event is WizardUpdateStage) {
        currentWizardStage = _UpdateStage(event.currentStage);
        yield currentState.copyWith(
          wizardStage: currentWizardStage,
          // iosAppTrackingPermission:
          //     await Permission.appTrackingTransparency.isGranted,
          // iosNotificationPermission: await Permission.notification.isGranted,
        );
      }
      if (event is WizardAcceptOneSignal) {
        yield currentState.copyWith(
          onesignalAccepted: event.accept,
        );
      }
      // if (event is WizardRejectOneSignalPermission) {
      //   await di.sl<Settings>().setIosNotificationPermissionDeclined(true);
      //   yield currentState.copyWith(onesignalPermissionRejected: true);
      // }
      // if (event is WizardUpdateIosAppTrackingPermission) {
      //   yield currentState.copyWith(
      //     iosAppTrackingPermission:
      //         await Permission.appTrackingTransparency.isGranted,
      //   );
      // }
      // if (event is WizardUpdateIosNotificationPermission) {
      //   yield currentState.copyWith(
      //     iosNotificationPermission: await Permission.notification.isGranted,
      //   );
      // }
    }
  }
}

WizardStage _UpdateStage(WizardStage currentStage) {
  switch (currentStage) {
    case (WizardStage.servers):
      return WizardStage.oneSignal;
    case (WizardStage.oneSignal):
      return WizardStage.closing;
    case (WizardStage.closing):
      return WizardStage.servers;
    default:
      return WizardStage.closing;
  }
}
