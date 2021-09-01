// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/terminate_session/data/datasources/terminate_session_data_source.dart';
import 'package:tautulli_remote/features/terminate_session/data/repositories/terminate_session_repository_impl.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

class MockTerminateSessionDataSource extends Mock
    implements TerminateSessionDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  TerminateSessionRepositoryImpl repository;
  MockTerminateSessionDataSource mockDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockDataSource = MockTerminateSessionDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TerminateSessionRepositoryImpl(
      dataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
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
    'should check if the device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockDataSource(
          tautulliId: anyNamed('tautulliId'),
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => true);
      //act
      await repository(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
        settingsBloc: settingsBloc,
      );
      //assert
      verify(mockNetworkInfo.isConnected);
    },
  );

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should call data source',
      () async {
        // arrange
        when(
          mockDataSource(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => true);
        // act
        await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockDataSource(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return true when api reports success',
      () async {
        // arrange
        when(
          mockDataSource(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => true);
        // act
        final result = await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(const Right(true)));
      },
    );

    test(
      'should return TerminateSessionFailure when api reports an error',
      () async {
        // arrange
        when(
          mockDataSource(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => false);
        // act
        final result = await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Left(TerminateFailure())));
      },
    );
  });

  group('device is offline', () {
    test(
      'should return a ConnectionFailure when there is no internet',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        //act
        final result = await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
          settingsBloc: settingsBloc,
        );
        //assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
