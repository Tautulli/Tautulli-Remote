// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/terminate_session/domain/usecases/terminate_session.dart';
import 'package:tautulli_remote/features/terminate_session/presentation/bloc/terminate_session_bloc.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

class MockTerminateSession extends Mock implements TerminateSession {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  MockTerminateSession mockTerminateSession;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;
  TerminateSessionBloc bloc;

  setUp(() {
    mockTerminateSession = MockTerminateSession();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );

    bloc = TerminateSessionBloc(
      terminateSession: mockTerminateSession,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const String tSessionId = 'm8bbpxpywe6i91zib3hnfltz';

  void setUpSuccess() {
    when(
      mockTerminateSession(
        tautulliId: anyNamed('tautulliId'),
        sessionId: anyNamed('sessionId'),
        message: anyNamed('message'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => const Right(true));
  }

  test(
    'initialState should be TerminateSessionInitial',
    () async {
      // assert
      expect(bloc.state, TerminateSessionInitial());
    },
  );

  group('TerminateSessionStarted', () {
    test(
      'should call TerminateSession use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          TerminateSessionStarted(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockTerminateSession(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(
          mockTerminateSession(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
      },
    );

    test(
      'should emit [TerminateSessionInProgress, TerminateSessionSuccess] when session is terminate successfully',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          TerminateSessionInProgress(sessionId: tSessionId),
          TerminateSessionSuccess(),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          TerminateSessionStarted(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [TerminateSessionInProgress, TerminateSessionFailure] when session fails to terminate',
      () async {
        // arrange
        when(
          mockTerminateSession(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => Left(TerminateFailure()));
        // assert later
        final expected = [
          TerminateSessionInProgress(sessionId: tSessionId),
          TerminateSessionFailure(failure: TerminateFailure()),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          TerminateSessionStarted(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );
  });
}
