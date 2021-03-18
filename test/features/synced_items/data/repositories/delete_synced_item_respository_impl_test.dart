import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/data/datasources/delete_synced_item_data_source.dart';
import 'package:tautulli_remote/features/synced_items/data/repositories/delete_synced_item_respository_impl.dart';

class MockDeleteSyncedItemDataSource extends Mock
    implements DeleteSyncedItemDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  DeleteSyncedItemRepositoryImpl repository;
  DeleteSyncedItemDataSource mockDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockDataSource = MockDeleteSyncedItemDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DeleteSyncedItemRepositoryImpl(
      dataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final String tClientId = 'abc';
  final int tSyncId = 123;

  test(
    'should check if the device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockDataSource(
          tautulliId: anyNamed('tautulliId'),
          clientId: anyNamed('clientId'),
          syncId: anyNamed('syncId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => true);
      //act
      await repository(
        tautulliId: tTautulliId,
        clientId: tClientId,
        syncId: tSyncId,
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
            clientId: anyNamed('clientId'),
            syncId: anyNamed('syncId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => true);
        // act
        await repository(
          tautulliId: tTautulliId,
          clientId: tClientId,
          syncId: tSyncId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockDataSource(
            tautulliId: tTautulliId,
            clientId: tClientId,
            syncId: tSyncId,
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
            clientId: anyNamed('clientId'),
            syncId: anyNamed('syncId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => true);
        // act
        final result = await repository(
          tautulliId: tTautulliId,
          clientId: tClientId,
          syncId: tSyncId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Right(true)));
      },
    );

    test(
      'should return DeleteSyncedFailure when api reports an error',
      () async {
        // arrange
        when(
          mockDataSource(
            tautulliId: anyNamed('tautulliId'),
            clientId: anyNamed('clientId'),
            syncId: anyNamed('syncId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => false);
        // act
        final result = await repository(
          tautulliId: tTautulliId,
          clientId: tClientId,
          syncId: tSyncId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(Left(DeleteSyncedFailure())));
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
          clientId: tClientId,
          syncId: tSyncId,
          settingsBloc: settingsBloc,
        );
        //assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
