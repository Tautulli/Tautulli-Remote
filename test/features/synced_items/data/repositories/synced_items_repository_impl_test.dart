import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/synced_items/data/datasources/synced_items_data_source.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/data/repositories/synced_items_repository_impl.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSyncedItemsDataSource extends Mock implements SyncedItemsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  SyncedItemsRepositoryImpl repository;
  MockSyncedItemsDataSource mockUsersDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockUsersDataSource = MockSyncedItemsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SyncedItemsRepositoryImpl(
      dataSource: mockUsersDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTautulliId = 'jkl';

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
        repository.getSyncedItems(tautulliId: tTautulliId);
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
          );
          // assert
          verify(
            mockUsersDataSource.getSyncedItems(
              tautulliId: tTautulliId,
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
            ),
          ).thenAnswer((_) async => tSyncedItemsList);
          // act
          final result = await repository.getSyncedItems(
            tautulliId: tTautulliId,
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
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
