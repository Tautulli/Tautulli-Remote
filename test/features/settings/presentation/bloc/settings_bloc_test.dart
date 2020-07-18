import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/entities/settings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/get_settings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/set_settings.dart';
import 'package:tautulli_remote_tdd/features/settings/presentation/bloc/settings_bloc.dart';

class MockGetSettings extends Mock implements GetSettings {}

class MockSetSettings extends Mock implements SetSettings {}

class MockLogging extends Mock implements Logging {}

void main() {
  SettingsBloc bloc;
  MockGetSettings mockGetSettings;
  MockSetSettings mockSetSettings;
  MockLogging mockLogging;

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockSetSettings = MockSetSettings();
    mockLogging = MockLogging();

    bloc = SettingsBloc(
      getSettings: mockGetSettings,
      setSettings: mockSetSettings,
      logging: mockLogging,
    );
  });

  final String tConnectionAddress = 'http://tautulli.com';
  final String tConnectionProtocol = 'http';
  final String tConnectionDomain = 'tautulli.com';
  final String tConnectionUser = null;
  final String tConnectionPassword = null;
  final String tDeviceToken = 'abc';
  final String tNewConnectionAddress = 'https://plexpy.com';
  final String tNewConnectionProtocol = 'https';
  final String tNewConnectionDomain = 'plexpy.com';
  final String tNewConnectionUser = 'user';
  final String tNewConnectionPassword = 'pass';
  final String tNewDeviceToken = 'def';

  final Settings tSettingsModel = SettingsModel(
    connectionAddress: tConnectionAddress,
    connectionProtocol: tConnectionProtocol,
    connectionDomain: tConnectionDomain,
    connectionUser: tConnectionUser,
    connectionPassword: tConnectionPassword,
    deviceToken: tDeviceToken,
  );
  final Settings tUpdatedSettingsModel = SettingsModel(
    connectionAddress: tNewConnectionAddress,
    connectionProtocol: tNewConnectionProtocol,
    connectionDomain: tNewConnectionDomain,
    connectionUser: tNewConnectionUser,
    connectionPassword: tNewConnectionPassword,
    deviceToken: tNewDeviceToken,
  );

  test(
    'initialState should be SettingsInitial',
    () async {
      // assert
      expect(bloc.state, SettingsInitial());
    },
  );

  test(
    'should get SettingsModel from the GetSettings.load() use case',
    () async {
      // arrange
      when(mockGetSettings.load()).thenAnswer((_) async => tSettingsModel);
      // act
      bloc.add(SettingsLoad());
      await untilCalled(mockGetSettings.load());
      // assert
      verify(mockGetSettings.load());
    },
  );

  test(
    'should emit [SettingsLoadInProgress, SettingsLoadSuccess] when Settings are loaded successfully',
    () async {
      // arrange
      when(mockGetSettings.load()).thenAnswer((_) async => tSettingsModel);
      // assert later
      final expected = [
        SettingsInitial(),
        SettingsLoadInProgress(),
        SettingsLoadSuccess(settings: tSettingsModel),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SettingsLoad());
    },
  );

  test(
    'should save connection details with the GetSettings.setConnection() use case',
    () async {
      // act
      bloc.add(SettingsUpdateConnection(value: tConnectionAddress));
      await untilCalled(mockSetSettings.setConnection(any));
      // assert
      verify(mockSetSettings.setConnection(tConnectionAddress));
    },
  );

  test(
    'should emit [SettingsLoadSuccess] when connectionAddress is updated',
    () async {
      // arrange
      when(mockGetSettings.load())
          .thenAnswer((_) async => tUpdatedSettingsModel);
      // assert later
      final expected = [
        SettingsInitial(),
        // SettingsLoadInProgress(),
        SettingsLoadSuccess(settings: tUpdatedSettingsModel),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SettingsUpdateConnection(value: tNewConnectionAddress));
    },
  );

  test(
    'should save Device Token with the GetSettings.setDeviceToken() use case',
    () async {
      // act
      bloc.add(SettingsUpdateDeviceToken(value: tDeviceToken));
      await untilCalled(mockSetSettings.setDeviceToken(any));
      // assert
      verify(mockSetSettings.setDeviceToken(tDeviceToken));
    },
  );

  test(
    'should emit [SettingsLoadSuccess] when Device Token is updated',
    () async {
      // arrange
      when(mockGetSettings.load())
          .thenAnswer((_) async => tUpdatedSettingsModel);
      // assert later
      final expected = [
        SettingsInitial(),
        // SettingsLoadInProgress(),
        SettingsLoadSuccess(settings: tUpdatedSettingsModel),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(SettingsUpdateDeviceToken(value: tNewDeviceToken));
    },
  );
}
