import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';
import 'package:tautulli_remote/features/settings/domain/repositories/settings_repository.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  Settings settings;
  MockSettingsRepository mockSettingsRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    settings = Settings(
      repository: mockSettingsRepository,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final int tId = 1;
  final int tSortIndex = 0;
  final String tPrimaryConnectionAddress = 'http://tautuli.domain.com';
  final String tPrimaryConnectionProtocol = 'http';
  final String tPrimaryConnectionDomain = 'tautuli.domain.com';
  final String tPrimaryConnectionPath = '/tautulli';
  final String tSecondaryConnectionAddress = 'http://tautuli.domain.com';
  final String tDeviceToken = 'abc';
  final String tTautulliId = 'jkl';
  final String tPlexName = 'Plex';
  final String tPlexIdentifier = 'xyz';
  final String tDateFormat = 'YYYY-MM-DD';
  final String tTimeFormat = 'HH:mm';

  final String tStatsType = 'duration';
  final String tLastAppVersion = '2.1.5';

  final ServerModel tServerModel = ServerModel(
    id: tId,
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

  final List<ServerModel> tServerList = [tServerModel];

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  final tautulliSettingsJson = json.decode(fixture('tautulli_settings.json'));
  final tautulliSettingsGeneral = TautulliSettingsGeneralModel.fromJson(
      tautulliSettingsJson['response']['data']['General']);
  final tTautulliSettingsMap = {
    'general': tautulliSettingsGeneral,
  };

  test(
    'addServer should forward the request to the repository',
    () async {
      // act
      settings.addServer(
        primaryConnectionAddress: tPrimaryConnectionAddress,
        deviceToken: tDeviceToken,
        tautulliId: tTautulliId,
        plexName: tPlexName,
        plexIdentifier: tPlexIdentifier,
        primaryActive: true,
        plexPass: true,
        sortIndex: tSortIndex,
      );
      // assert
      verify(
        mockSettingsRepository.addServer(
          primaryConnectionAddress: tPrimaryConnectionAddress,
          deviceToken: tDeviceToken,
          tautulliId: tTautulliId,
          plexName: tPlexName,
          plexIdentifier: tPlexIdentifier,
          primaryActive: true,
          plexPass: true,
          sortIndex: tSortIndex,
        ),
      );
    },
  );

  test(
    'deleteServer should forward the request to the repository',
    () async {
      // act
      settings.deleteServer(tId);
      // assert
      verify(mockSettingsRepository.deleteServer(tId));
    },
  );

  test(
    'updateServer should forward the request to the repository',
    () async {
      // act
      settings.updateServer(tServerModel);
      // assert
      verify(mockSettingsRepository.updateServer(tServerModel));
    },
  );

  test(
    'updateServerById should forward the request to the repository',
    () async {
      // act
      settings.updateServerById(
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
        sortIndex: tSortIndex,
      );
      // assert
      verify(
        mockSettingsRepository.updateServerById(
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
          sortIndex: tSortIndex,
        ),
      );
    },
  );

  test(
    'getAllServers should return a List of ServerModel',
    () async {
      // arrange
      when(mockSettingsRepository.getAllServers())
          .thenAnswer((_) async => tServerList);
      // act
      final List<ServerModel> servers = await settings.getAllServers();
      // assert
      expect(servers, equals(tServerList));
    },
  );

  test(
    'getServer should return a single ServerModel',
    () async {
      // arrange
      when(mockSettingsRepository.getServer(any))
          .thenAnswer((_) async => tServerModel);
      // act
      final server = await settings.getServer(tId);
      // assert
      expect(server, equals(tServerModel));
    },
  );

  test(
    'getServerByTautulliId should return a single ServerModel',
    () async {
      // arrange
      when(mockSettingsRepository.getServerByTautulliId(any))
          .thenAnswer((_) async => tServerModel);
      // act
      final server = await settings.getServerByTautulliId(tTautulliId);
      // assert
      expect(server, equals(tServerModel));
    },
  );

  test(
    'updatePrimaryConnection should forward the request to the repository',
    () async {
      // act
      settings.updatePrimaryConnection(
        id: tId,
        primaryConnectionAddress: tPrimaryConnectionAddress,
      );
      // assert
      verify(
        mockSettingsRepository.updatePrimaryConnection(
          id: tId,
          primaryConnectionAddress: tPrimaryConnectionAddress,
        ),
      );
    },
  );

  test(
    'updateSecondaryConnection should forward the request to the repository',
    () async {
      // act
      settings.updateSecondaryConnection(
        id: tId,
        secondaryConnectionAddress: tPrimaryConnectionAddress,
      );
      // assert
      verify(
        mockSettingsRepository.updateSecondaryConnection(
          id: tId,
          secondaryConnectionAddress: tPrimaryConnectionAddress,
        ),
      );
    },
  );

  test(
    'updateDeviceToken should forward the request to the repository',
    () async {
      // act
      settings.updateDeviceToken(
        id: tId,
        deviceToken: tDeviceToken,
      );
      // assert
      verify(
        mockSettingsRepository.updateDeviceToken(
          id: tId,
          deviceToken: tDeviceToken,
        ),
      );
    },
  );

  test(
    'updateServerSort should forward the request to the repository',
    () async {
      // act
      settings.updateServerSort(
        serverId: tId,
        oldIndex: 0,
        newIndex: 1,
      );
      // assert
      verify(
        mockSettingsRepository.updateServerSort(
          serverId: tId,
          oldIndex: 0,
          newIndex: 1,
        ),
      );
    },
  );

  test(
    'should get PlexServerInfo from repository',
    () async {
      // arrange
      when(
        mockSettingsRepository.getPlexServerInfo(
          tautulliId: anyNamed('tautulliId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tPlexServerInfo));
      // act
      final result = await settings.getPlexServerInfo(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tPlexServerInfo)));
    },
  );

  test(
    'should get TautulliSettings from repository',
    () async {
      // arrange
      when(
        mockSettingsRepository.getTautulliSettings(
          tautulliId: anyNamed('tautulliId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tTautulliSettingsMap));
      // act
      final result = await settings.getTautulliSettings(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tTautulliSettingsMap)));
    },
  );

  test(
    'getServerTimeout should get server timeout from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getServerTimeout())
          .thenAnswer((_) async => 3);
      // act
      final result = await settings.getServerTimeout();
      // assert
      expect(result, equals(3));
      verify(mockSettingsRepository.getServerTimeout());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setServerTimeout should forward request to the repository',
    () async {
      // act
      await settings.setServerTimeout(3);
      // assert
      verify(mockSettingsRepository.setServerTimeout(3));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getRefreshRate should get refresh rate from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getRefreshRate()).thenAnswer((_) async => 3);
      // act
      final result = await settings.getRefreshRate();
      // assert
      expect(result, equals(3));
      verify(mockSettingsRepository.getRefreshRate());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setRefreshRate should forward request to the repository',
    () async {
      // act
      await settings.setRefreshRate(3);
      // assert
      verify(mockSettingsRepository.setRefreshRate(3));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getDoubleTapToExit should get double tap to exit value from settings',
    () async {
      // arrange
      when(
        mockSettingsRepository.getDoubleTapToExit(),
      ).thenAnswer((_) async => true);
      // act
      final result = await settings.getDoubleTapToExit();
      // assert
      expect(result, equals(true));
      verify(mockSettingsRepository.getDoubleTapToExit());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setDoubleTapToExit should forward request to the repository',
    () async {
      // act
      await settings.setDoubleTapToExit(true);
      // assert
      verify(mockSettingsRepository.setDoubleTapToExit(true));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getMaskSensitiveInfo should get mask sensitive info value from settings',
    () async {
      // arrange
      when(
        mockSettingsRepository.getMaskSensitiveInfo(),
      ).thenAnswer((_) async => true);
      // act
      final result = await settings.getMaskSensitiveInfo();
      // assert
      expect(result, equals(true));
      verify(mockSettingsRepository.getMaskSensitiveInfo());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setMaskSensitiveInfo should forward request to the repository',
    () async {
      // act
      await settings.setMaskSensitiveInfo(true);
      // assert
      verify(mockSettingsRepository.setMaskSensitiveInfo(true));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getLastSelectedServer should get last selected server from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getLastSelectedServer())
          .thenAnswer((_) async => tTautulliId);
      // act
      final result = await settings.getLastSelectedServer();
      // assert
      expect(result, equals(tTautulliId));
      verify(mockSettingsRepository.getLastSelectedServer());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setLastSelectedServer should forward request to the repository',
    () async {
      // act
      await settings.setLastSelectedServer(tTautulliId);
      // assert
      verify(mockSettingsRepository.setLastSelectedServer(tTautulliId));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getStatsType should get stats type from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getStatsType())
          .thenAnswer((_) async => tStatsType);
      // act
      final result = await settings.getStatsType();
      // assert
      expect(result, equals(tStatsType));
      verify(mockSettingsRepository.getStatsType());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setStatsType should forward request to the repository',
    () async {
      // act
      await settings.setStatsType(tStatsType);
      // assert
      verify(mockSettingsRepository.setStatsType(tStatsType));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getLastAppVersion should get the last app version from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getLastAppVersion())
          .thenAnswer((_) async => tLastAppVersion);
      // act
      final result = await settings.getLastAppVersion();
      // assert
      expect(result, equals(tLastAppVersion));
      verify(mockSettingsRepository.getLastAppVersion());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setLastAppVersion should forward request to the repository',
    () async {
      // act
      await settings.setLastAppVersion(tLastAppVersion);
      // assert
      verify(mockSettingsRepository.setLastAppVersion(tLastAppVersion));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getLastReadAnnouncementId should get read announcement count from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getLastReadAnnouncementId())
          .thenAnswer((_) async => 1);
      // act
      final result = await settings.getLastReadAnnouncementId();
      // assert
      expect(result, equals(1));
      verify(mockSettingsRepository.getLastReadAnnouncementId());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setLastReadAnnouncementId should forward request to the repository',
    () async {
      // act
      await settings.setLastReadAnnouncementId(1);
      // assert
      verify(mockSettingsRepository.setLastReadAnnouncementId(1));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'getCustomCertHashList should get customer cert hash list from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getCustomCertHashList())
          .thenAnswer((_) async => [1, 2]);
      // act
      final result = await settings.getCustomCertHashList();
      // assert
      expect(result, equals([1, 2]));
      verify(mockSettingsRepository.getCustomCertHashList());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'setCustomCertHashList should forward request to the repository',
    () async {
      // act
      await settings.setCustomCertHashList([1, 2]);
      // assert
      verify(mockSettingsRepository.setCustomCertHashList([1, 2]));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
