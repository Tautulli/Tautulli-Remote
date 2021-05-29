import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/wizard/presentation/bloc/wizard_bloc.dart';

void main() {
  WizardBloc bloc;

  setUp(() {
    bloc = WizardBloc();
  });

  test(
    'initialState should be RegisterDeviceInitial',
    () async {
      // assert
      expect(
        bloc.state,
        WizardLoaded(
          wizardStage: WizardStage.servers,
        ),
      );
    },
  );

  group('WizardUpdateStage', () {
    test(
      'should emit [WizardLoaded] with wizard stage incremented',
      () async {
        // act
        final currentState = WizardLoaded(wizardStage: WizardStage.servers);
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(wizardStage: WizardStage.oneSignal),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(WizardUpdateStage(WizardStage.servers));
      },
    );
  });

  group('WizardAcceptOneSignal', () {
    test(
      'should emit [WizardLoaded] with oneSignalAccepted as true when passed a bool of true',
      () async {
        // act
        final currentState = WizardLoaded(wizardStage: WizardStage.oneSignal);
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(onesignalAccepted: true),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(WizardAcceptOneSignal(true));
      },
    );
    test(
      'should emit [WizardLoaded] with oneSignalAccepted as false when passed a bool of false',
      () async {
        // act
        final currentState = WizardLoaded(
          wizardStage: WizardStage.oneSignal,
          onesignalAccepted: true,
        );
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(onesignalAccepted: false),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(WizardAcceptOneSignal(false));
      },
    );
  });
}
