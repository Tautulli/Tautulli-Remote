import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockGetServerInfo extends Mock implements tautulliApi.GetServerInfo {}

class MockGetSettings extends Mock implements tautulliApi.GetSettings {}

void main() {
  SettingsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  MockGetServerInfo mockApiGetServerInfo;
  MockGetSettings mockApiGetSettings;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockApiGetServerInfo = MockGetServerInfo();
    mockApiGetSettings = MockGetSettings();
    dataSource = SettingsDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      apiGetServerInfo: mockApiGetServerInfo,
      apiGetSettings: mockApiGetSettings,
    );
  });

  final String tTautulliId = 'jkl';

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  final tautulliSettingsJson = json.decode(fixture('tautulli_settings.json'));
  final tautulliSettingsGeneral = TautulliSettingsGeneralModel.fromJson(
      tautulliSettingsJson['response']['data']['General']);
  final tTautulliSettingsMap = {
    'general': tautulliSettingsGeneral,
  };

  group('Plex Server Info', () {
    test(
      'should call [getServerInfo] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetServerInfo(any),
        ).thenAnswer((_) async => plexServerInfoJson);
        // act
        await dataSource.getPlexServerInfo(tTautulliId);
        // assert
        verify(
          mockApiGetServerInfo(tTautulliId),
        );
      },
    );

    test(
      'should return a PlexServerInfo item',
      () async {
        // arrange
        when(
          mockApiGetServerInfo(any),
        ).thenAnswer((_) async => plexServerInfoJson);
        // act
        final result = await dataSource.getPlexServerInfo(tTautulliId);
        // assert
        expect(result, equals(tPlexServerInfo));
      },
    );
  });

  group('Tautulli Settings', () {
    test(
      'should call [getSettings] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetSettings(any),
        ).thenAnswer((_) async => tautulliSettingsJson);
        // act
        await dataSource.getTautulliSettings(tTautulliId);
        // assert
        verify(
          mockApiGetSettings(tTautulliId),
        );
      },
    );

    test(
      'should return a Map of TautulliSettings items',
      () async {
        // arrange
        when(
          mockApiGetSettings(any),
        ).thenAnswer((_) async => tautulliSettingsJson);
        // act
        final result = await dataSource.getTautulliSettings(tTautulliId);
        // assert
        expect(result, equals(tTautulliSettingsMap));
      },
    );
  });

  group('Server Timeout', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_SERVER_TIMEOUT))
            .thenReturn(3);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        verify(mockSharedPreferences.getInt(SETTINGS_SERVER_TIMEOUT));
        expect(serverTimeout, equals(3));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_SERVER_TIMEOUT))
            .thenReturn(null);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        expect(serverTimeout, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the server timeout',
      () async {
        // act
        await dataSource.setServerTimeout(3);
        // assert
        verify(mockSharedPreferences.setInt(SETTINGS_SERVER_TIMEOUT, 3));
      },
    );
  });

  group('Refresh Rate', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE)).thenReturn(3);
        // act
        final refreshRate = await dataSource.getRefreshRate();
        // assert
        verify(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE));
        expect(refreshRate, equals(3));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE))
            .thenReturn(null);
        // act
        final refreshRate = await dataSource.getRefreshRate();
        // assert
        expect(refreshRate, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the refresh rate',
      () async {
        // act
        await dataSource.setRefreshRate(3);
        // assert
        verify(mockSharedPreferences.setInt(SETTINGS_REFRESH_RATE, 3));
      },
    );
  });

  group('Last Selected Server', () {
    test(
      'should return String from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getString(LAST_SELECTED_SERVER))
            .thenReturn('jkl');
        // act
        final lastSelectedServer = await dataSource.getLastSelectedServer();
        // assert
        verify(mockSharedPreferences.getString(LAST_SELECTED_SERVER));
        expect(lastSelectedServer, equals('jkl'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(LAST_SELECTED_SERVER))
            .thenReturn(null);
        // act
        final lastSelectedServer = await dataSource.getLastSelectedServer();
        // assert
        expect(lastSelectedServer, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the last selected server',
      () async {
        // act
        await dataSource.setLastSelectedServer('jkl');
        // assert
        verify(mockSharedPreferences.setString(LAST_SELECTED_SERVER, 'jkl'));
      },
    );
  });

  group('Stats Type', () {
    test(
      'should return String from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getString(STATS_TYPE))
            .thenReturn('duration');
        // act
        final statsType = await dataSource.getStatsType();
        // assert
        verify(mockSharedPreferences.getString(STATS_TYPE));
        expect(statsType, equals('duration'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(STATS_TYPE)).thenReturn(null);
        // act
        final statsType = await dataSource.getStatsType();
        // assert
        expect(statsType, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the stats type',
      () async {
        // act
        await dataSource.setStatsType('duration');
        // assert
        verify(mockSharedPreferences.setString(STATS_TYPE, 'duration'));
      },
    );
  });
}
