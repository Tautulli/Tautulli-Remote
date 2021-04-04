import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/terminate_session/data/datasources/terminate_session_data_source.dart';

class MockTerminateSession extends Mock
    implements tautulli_api.TerminateSession {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  TerminateSessionDataSourceImpl dataSource;
  MockTerminateSession mockApiTerminateSession;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiTerminateSession = MockTerminateSession();
    dataSource = TerminateSessionDataSourceImpl(
      apiTerminateSession: mockApiTerminateSession,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const String tSessionId = 'm8bbpxpywe6i91zib3hnfltz';

  final Map<String, dynamic> successMap = {
    'response': {
      'result': 'success',
    }
  };

  final Map<String, dynamic> failureMap = {
    'response': {
      'result': 'error',
    }
  };

  test(
    'should call [terminateSession] from TautulliApi',
    () async {
      // arrange
      when(
        mockApiTerminateSession(
          tautulliId: anyNamed('tautulliId'),
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => successMap);
      // act
      await dataSource(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
        settingsBloc: settingsBloc,
      );
      // assert
      verify(
        mockApiTerminateSession(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );

  test(
    'should return true is termination is successful',
    () async {
      // arrange
      when(
        mockApiTerminateSession(
          tautulliId: anyNamed('tautulliId'),
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => successMap);
      // act
      final result = await dataSource(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(true));
    },
  );

  test(
    'should return false is termination fails',
    () async {
      // arrange
      when(
        mockApiTerminateSession(
          tautulliId: anyNamed('tautulliId'),
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => failureMap);
      // act
      final result = await dataSource(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(false));
    },
  );
}
