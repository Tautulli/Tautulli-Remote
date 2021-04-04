import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/synced_items/data/datasources/synced_items_data_source.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/data/repositories/synced_items_repository_impl.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSyncedItemsDataSource extends Mock implements SyncedItemsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  SyncedItemsRepositoryImpl repository;
  MockSyncedItemsDataSource mockUsersDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockUsersDataSource = MockSyncedItemsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SyncedItemsRepositoryImpl(
      dataSource: mockUsersDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'jkl';

  final List<SyncedItem> tSyncedItemsList = [];
  final usersJson = json.decode(fixture('synced_items.json'));

  usersJson['response']['data'].forEach((item) {
    tSyncedItemsList.add(SyncedItemModel.fromJson(item));
  });

  group('getSyncedItems', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getSyncedItems(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getSyncedItems()',
        () async {
          // act
          await repository.getSyncedItems(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockUsersDataSource.getSyncedItems(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of SyncedItem when call to API is successful',
        () async {
          // arrange
          when(
            mockUsersDataSource.getSyncedItems(
              tautulliId: anyNamed('tautulliId'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tSyncedItemsList);
          // act
          final result = await repository.getSyncedItems(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tSyncedItemsList)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getSyncedItems(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
