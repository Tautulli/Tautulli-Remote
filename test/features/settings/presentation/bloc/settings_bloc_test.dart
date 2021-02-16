import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/core/database/domain/entities/server.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

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
  final String tPlexIdentifier = 'uvw';
  final String tDateFormat = 'YYYY-MM-DD';
  final String tTimeFormat = 'HH:mm';

  final Server tServerModel = ServerModel(
    primaryConnectionAddress: tPrimaryConnectionAddress,
    primaryConnectionProtocol: tPrimaryConnectionProtocol,
    primaryConnectionDomain: tPrimaryConnectionDomain,
    primaryConnectionPath: tPrimaryConnectionPath,
    deviceToken: tDeviceToken,
    tautulliId: tTautulliId,
    plexName: tPlexName,
    plexIdentifier: tPlexIdentifier,
    primaryActive: true,
    plexPass: true,
    dateFormat: tDateFormat,
    timeFormat: tTimeFormat,
  );

  final Map<String, dynamic> tTautulliSettings = {
    'general': TautulliSettingsGeneralModel(
      dateFormat: tDateFormat,
      timeFormat: tTimeFormat,
    ),
  };

  final List<ServerModel> tServerList = [tServerModel];

  final int tServerTimeout = 5;
  final int tRefreshRate = 10;
  final bool tMaskSensitiveInfo = true;
  final String tStatsType = 'duration';

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  void setUpSuccess() {
    when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
    when(mockSettings.getServerTimeout())
        .thenAnswer((_) async => tServerTimeout);
    when(mockSettings.getRefreshRate()).thenAnswer((_) async => tRefreshRate);
    when(mockSettings.getMaskSensitiveInfo())
        .thenAnswer((_) async => tMaskSensitiveInfo);
    when(mockSettings.getLastSelectedServer())
        .thenAnswer((_) async => tTautulliId);
    when(mockSettings.getStatsType()).thenAnswer((_) async => tStatsType);
    when(mockSettings.getPlexServerInfo(any))
        .thenAnswer((_) async => Right(tPlexServerInfo));
    when(mockSettings.getTautulliSettings(any))
        .thenAnswer((_) async => Right(tTautulliSettings));
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
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
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
            plexIdentifier: tPlexIdentifier,
            plexPass: true,
          ),
        );
        await untilCalled(
          mockSettings.addServer(
            primaryConnectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            tautulliId: tTautulliId,
            plexName: tPlexName,
            plexIdentifier: tPlexIdentifier,
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
            plexIdentifier: tPlexIdentifier,
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
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
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
            plexIdentifier: tPlexIdentifier,
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
            plexIdentifier: tPlexIdentifier,
            plexPass: true,
            dateFormat: tDateFormat,
            timeFormat: tTimeFormat,
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
            plexIdentifier: tPlexIdentifier,
            primaryActive: true,
            plexPass: true,
            dateFormat: tDateFormat,
            timeFormat: tTimeFormat,
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
            plexIdentifier: tPlexIdentifier,
            primaryActive: true,
            plexPass: true,
            dateFormat: tDateFormat,
            timeFormat: tTimeFormat,
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
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
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
            plexIdentifier: tPlexIdentifier,
            plexPass: true,
            dateFormat: tDateFormat,
            timeFormat: tTimeFormat,
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
        bloc.add(SettingsDeleteServer(
          id: tId,
          plexName: tPlexName,
        ));
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
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(SettingsDeleteServer(
          id: tId,
          plexName: tPlexName,
        ));
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
            plexName: tPlexName,
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
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdatePrimaryConnection(
            id: tId,
            plexName: tPlexName,
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
            plexName: tPlexName,
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
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateSecondaryConnection(
            id: tId,
            plexName: tPlexName,
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
            plexName: tPlexName,
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
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          SettingsUpdateDeviceToken(
            id: tId,
            plexName: tPlexName,
            deviceToken: tDeviceToken,
          ),
        );
      },
    );
  });
}
