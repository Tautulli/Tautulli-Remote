import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/core/database/domain/entities/server.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  SettingsBloc bloc;
  MockSettings mockSettings;
  MockLogging mockLogging;

  setUp(() {
    mockSettings = MockSettings();
    mockLogging = MockLogging();

    bloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final int tId = 1;
  final String tPrimaryConnectionAddress = 'http://tautulli.com';
  final String tPrimaryConnectionProtocol = 'http';
  final String tPrimaryConnectionDomain = 'tautulli.com';
  final String tPrimaryConnectionPath = '/tautulli';
  final String tSecondaryConnectionAddress = 'http://tautulli.com';
  final String tDeviceToken = 'abc';
  final String tTautulliId = 'jkl';
  final String tPlexName = 'Plex';
  final String tNewPrimaryConnectionAddress = 'https://plexpy.com';
  final String tNewPrimaryConnectionProtocol = 'https';
  final String tNewPrimaryConnectionDomain = 'plexpy.com';
  final String tNewPrimaryConnectionPath = '/plexpy';
  final String tNewDeviceToken = 'def';
  final String tNewTautulliId = 'mno';
  final String tNewPlexName = 'Plex2';

  final Server tServerModel = ServerModel(
    primaryConnectionAddress: tPrimaryConnectionAddress,
    primaryConnectionProtocol: tPrimaryConnectionProtocol,
    primaryConnectionDomain: tPrimaryConnectionDomain,
    primaryConnectionPath: tPrimaryConnectionPath,
    deviceToken: tDeviceToken,
    tautulliId: tTautulliId,
    plexName: tPlexName,
    primaryActive: true,
    plexPass: true,
  );

  final List<ServerModel> tServerList = [tServerModel];

  final int tServerTimeout = 5;
  final int tRefreshRate = 10;

  void setUpSuccess() {
    when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
    when(mockSettings.getServerTimeout())
        .thenAnswer((_) async => tServerTimeout);
    when(mockSettings.getRefreshRate()).thenAnswer((_) async => tRefreshRate);
    when(mockSettings.getLastSelectedServer())
        .thenAnswer((_) async => tTautulliId);
  }

  test(
    'initialState should be SettingsInitial',
    () async {
      // assert
      expect(bloc.state, SettingsInitial());
    },
  );

  group('SettingsLoad', () {
    test(
      'should get SettingsModel from the Settings.getAllServers() use case',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // act
        bloc.add(SettingsLoad());
        await untilCalled(mockSettings.getAllServers());
        // assert
        verify(mockSettings.getAllServers());
      },
    );

    test(
      'should emit [SettingsLoadInProgress, SettingsLoadSuccess] when Settings are loaded successfully',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadInProgress(),
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            lastSelectedServer: tTautulliId,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SettingsLoad());
      },
    );
  });

  group('SettingsAddServer', () {
    test(
      'should call Settings.addServer() use case',
      () async {
        // act
        bloc.add(
          SettingsAddServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            plexPass: true,
          ),
        );
        await untilCalled(
          mockSettings.addServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            primaryActive: true,
            plexPass: true,
          ),
        );
        // assert
        verify(
          mockSettings.addServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            primaryActive: true,
            plexPass: true,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after adding a server',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            lastSelectedServer: tTautulliId,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsAddServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            plexPass: true,
          ),
        );
      },
    );
  });

  group('SettingsUpdateServer', () {
    test(
      'should call the Settings.updateServerById use case',
      () async {
        // act
        bloc.add(
          SettingsUpdateServer(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            plexPass: true,
          ),
        );
        await untilCalled(
          mockSettings.updateServerById(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            primaryActive: true,
            plexPass: true,
          ),
        );
        // assert
        verify(
          mockSettings.updateServerById(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            primaryActive: true,
            plexPass: true,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a server',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            lastSelectedServer: tTautulliId,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateServer(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
            secondaryConnectionAddress: tSecondaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            plexPass: true,
          ),
        );
      },
    );
  });

  group('SettingsDeleteServer', () {
    test(
      'should call the Settings.deleteServer use case',
      () async {
        // act
        bloc.add(SettingsDeleteServer(id: tId));
        await untilCalled(mockSettings.deleteServer(tId));
        // assert
        verify(mockSettings.deleteServer(tId));
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after deleting a server',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            lastSelectedServer: tTautulliId,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SettingsDeleteServer(id: tId));
      },
    );
  });

  group('SettingsUpdatePrimaryConnection', () {
    test(
      'should call the Settings.updatePrimaryConnection use case',
      () async {
        // act
        bloc.add(
          SettingsUpdatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        await untilCalled(
          mockSettings.updatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        // assert
        verify(
          mockSettings.updatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a primary connection',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            lastSelectedServer: tTautulliId,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdatePrimaryConnection(
            id: tId,
            primaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );
  });

  group('SettingsUpdateSecondaryConnection', () {
    test(
      'should call the Settings.updateSecondaryConnection use case',
      () async {
        // act
        bloc.add(
          SettingsUpdateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        await untilCalled(
          mockSettings.updateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
        // assert
        verify(
          mockSettings.updateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a secondary connection',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            lastSelectedServer: tTautulliId,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateSecondaryConnection(
            id: tId,
            secondaryConnectionAddress: tPrimaryConnectionAddress,
          ),
        );
      },
    );
  });

  group('SettingsUpdateDeviceToken', () {
    test(
      'should call the Settings.updateDeviceToken use case',
      () async {
        // act
        bloc.add(
          SettingsUpdateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
        await untilCalled(
          mockSettings.updateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
        // assert
        verify(
          mockSettings.updateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
      },
    );

    test(
      'should emit [SettingsLoadSuccess] after updating a secondary connection',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            lastSelectedServer: tTautulliId,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateDeviceToken(
            id: tId,
            deviceToken: tDeviceToken,
          ),
        );
      },
    );
  });
}
