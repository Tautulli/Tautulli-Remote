import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautulli_remote_tdd/features/settings/data/datasources/settings_data_source.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SettingsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        SettingsDataSourceImpl(sharedPreferences: mockSharedPreferences);
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
        when(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE))
            .thenReturn(3);
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
}
