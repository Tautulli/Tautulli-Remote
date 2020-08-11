import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/helpers/connection_address_helper.dart';
import 'package:tautulli_remote_tdd/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote_tdd/features/settings/data/repositories/settings_repository_impl.dart';

class MockSettingsDataSource extends Mock implements SettingsDataSource {}

class MockConnectionAddressHelper extends Mock
    implements ConnectionAddressHelper {}

void main() {
  SettingsRepositoryImpl repository;
  MockSettingsDataSource mockSettingsDataSource;
  MockConnectionAddressHelper mockConnectionAddressHelper;

  setUp(() {
    mockSettingsDataSource = MockSettingsDataSource();
    mockConnectionAddressHelper = MockConnectionAddressHelper();
    repository = SettingsRepositoryImpl(
      dataSource: mockSettingsDataSource,
      connectionAddressHelper: mockConnectionAddressHelper,
    );
  });

  final int tServerTimeout = 3;
  final int tRefreshRate = 5;
  final String tTautulliId = 'jkl';

  group('Server Timeout', () {
    test(
      'should return the server timeout from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getServerTimeout())
            .thenAnswer((_) async => tServerTimeout);
        // act
        final result = await repository.getServerTimeout();
        // assert
        expect(result, equals(tServerTimeout));
      },
    );

    test(
      'should formward the call to the data source to set server timeout',
      () async {
        // act
        await repository.setServerTimeout(tServerTimeout);
        // assert
        verify(mockSettingsDataSource.setServerTimeout(tServerTimeout));
      },
    );
  });

  group('Refresh Rate', () {
    test(
      'should return the refresh rate from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getRefreshRate())
            .thenAnswer((_) async => tRefreshRate);
        // act
        final result = await repository.getRefreshRate();
        // assert
        expect(result, equals(tRefreshRate));
      },
    );

    test(
      'should formward the call to the data source to set refresh rate',
      () async {
        // act
        await repository.setRefreshRate(tRefreshRate);
        // assert
        verify(mockSettingsDataSource.setRefreshRate(tRefreshRate));
      },
    );
  });

   group('Last Selected Server', () {
    test(
      'should return the last selected server from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getLastSelectedServer())
            .thenAnswer((_) async => tTautulliId);
        // act
        final result = await repository.getLastSelectedServer();
        // assert
        expect(result, equals(tTautulliId));
      },
    );

    test(
      'should formward the call to the data source to set last selected server',
      () async {
        // act
        await repository.setLastSelectedServer(tTautulliId);
        // assert
        verify(mockSettingsDataSource.setLastSelectedServer(tTautulliId));
      },
    );
  });
}
