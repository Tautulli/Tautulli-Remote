import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautulli_remote/core/api/tautulli_api.dart';
import 'package:tautulli_remote/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockTautulliApi extends Mock implements TautulliApi {}

void main() {
  SettingsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  MockTautulliApi mockTautulliApi;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockTautulliApi = MockTautulliApi();
    dataSource = SettingsDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      tautulliApi: mockTautulliApi,
    );
  });

  final String tTautulliId = 'jkl';

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  group('Plex Server Info', () {
    test(
      'should call [getServerInfo] from TautulliApi',
      () async {
        // arrange
        when(
          mockTautulliApi.getServerInfo(any),
        ).thenAnswer((_) async => plexServerInfoJson);
        // act
        await dataSource.getPlexServerInfo(tTautulliId);
        // assert
        verify(
          mockTautulliApi.getServerInfo(tTautulliId),
        );
      },
    );

    test(
      'should return a PlexServerInfo item',
      () async {
        // arrange
        when(
          mockTautulliApi.getServerInfo(any),
        ).thenAnswer((_) async => plexServerInfoJson);
        // act
        final result = await dataSource.getPlexServerInfo(tTautulliId);
        // assert
        expect(result, equals(tPlexServerInfo));
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
        final serverTimeout = await dataSource.getRefreshRate();
        // assert
        verify(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE));
        expect(serverTimeout, equals(3));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE))
            .thenReturn(null);
        // act
        final serverTimeout = await dataSource.getRefreshRate();
        // assert
        expect(serverTimeout, equals(null));
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
        final serverTimeout = await dataSource.getLastSelectedServer();
        // assert
        verify(mockSharedPreferences.getString(LAST_SELECTED_SERVER));
        expect(serverTimeout, equals('jkl'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(LAST_SELECTED_SERVER))
            .thenReturn(null);
        // act
        final serverTimeout = await dataSource.getLastSelectedServer();
        // assert
        expect(serverTimeout, equals(null));
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
}
