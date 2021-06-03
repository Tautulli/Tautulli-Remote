import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/terminate_session/domain/repositories/terminate_session_repository.dart';
import 'package:tautulli_remote/features/terminate_session/domain/usecases/terminate_session.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

class MockTerminateSessionRepository extends Mock
    implements TerminateSessionRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  TerminateSession usecase;
  MockTerminateSessionRepository mockTerminateSessionRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockTerminateSessionRepository = MockTerminateSessionRepository();
    usecase = TerminateSession(
      repository: mockTerminateSessionRepository,
    );
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
  });

  const String tTautulliId = 'jkl';
  const String tSessionId = 'm8bbpxpywe6i91zib3hnfltz';

  test(
    'should return true when session is terminated successfully',
    () async {
      // arrange
      when(
        mockTerminateSessionRepository(
          tautulliId: anyNamed('tautulliId'),
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => const Right(true));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(const Right(true)));
    },
  );
}
