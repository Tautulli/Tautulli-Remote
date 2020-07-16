import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/entities/settings.dart';

class MockSettingsDataSource extends Mock implements SettingsDataSource {}

void main() {
  SettingsRepositoryImpl repository;
  MockSettingsDataSource dataSource;

  setUp(() {
    dataSource = MockSettingsDataSource();
    repository = SettingsRepositoryImpl(dataSource: dataSource);
  });

  final tConnectionAddress = 'https://tautulli.com';
  final tConnectionProtocol = 'http';
  final tConnectionDomain = 'tautulli.com';
  final tConnectionUser = 'user';
  final tConnectionPassword = 'pass';
  final tDeviceToken = 'abc';

  final tSettingsModel = SettingsModel(
      connectionAddress: tConnectionAddress,
      connectionProtocol: tConnectionProtocol,
      connectionDomain: tConnectionDomain,
      connectionUser: tConnectionUser,
      connectionPassword: tConnectionPassword,
      deviceToken: tDeviceToken,
    );

  group('getConnectionAddress', () {
    test(
      'should return the connectionAddress from settings when one is stored',
      () async {
        // arrange
        when(dataSource.getConnectionAddress()).thenAnswer((_) async => tConnectionAddress);
        // act
        final result = await repository.getConnectionAddress();
        // assert
        verify(dataSource.getConnectionAddress());
        expect(result, equals(tConnectionAddress));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(dataSource.getConnectionAddress()).thenReturn(null);
        // act
        final result = await repository.getConnectionAddress();
        // assert
        verify(dataSource.getConnectionAddress());
        expect(result, equals(null));
      },
    );
  });

  group('getDeviceToken', () {
    test(
      'should return the deviceToken from settings when one is stored',
      () async {
        // arrange
        when(dataSource.getDeviceToken()).thenAnswer((_) async => tDeviceToken);
        // act
        final result = await repository.getDeviceToken();
        // assert
        verify(dataSource.getDeviceToken());
        expect(result, equals(tDeviceToken));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(dataSource.getDeviceToken()).thenReturn(null);
        // act
        final result = await repository.getDeviceToken();
        // assert
        verify(dataSource.getDeviceToken());
        expect(result, equals(null));
      },
    );
  });

  group('load', () {
    test(
      'should return a SettingsModel with all saved settings',
      () async {
        // arrange
        when(dataSource.load()).thenAnswer((_) async => tSettingsModel);
        // act
        final result = await repository.load();
        // assert
        verify(dataSource.load());
        expect(result, equals(tSettingsModel));
      },
    );
  });

  group('Set settings', () {
    test(
      'setConnection should forward the call to the data source',
      () async {
        // act
        await repository.setConnection(tConnectionAddress);
        // assert
        verify(dataSource.setConnection(tConnectionAddress));
      },
    );

    test(
      'setDeviceToken should forward the call to the data source',
      () async {
        // act
        await repository.setDeviceToken(tDeviceToken);
        // assert
        verify(dataSource.setDeviceToken(tDeviceToken));
      },
    );

    test(
      'save() should forward the call to the data source',
      () async {
        // act
        await repository.save(tSettingsModel);
        // assert
        verify(dataSource.save(tSettingsModel));
      },
    );
  });
}
