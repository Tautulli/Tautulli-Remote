import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api.dart';
import 'package:tautulli_remote/features/synced_items/data/datasources/synced_items_data_source.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

void main() {
  SyncedItemsDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    dataSource = SyncedItemsDataSourceImpl(
      tautulliApi: mockTautulliApi,
    );
  });

  final String tTautulliId = 'jkl';

  final List<SyncedItem> tSyncedItemList = [];
  final syncedItemsJson = json.decode(fixture('synced_items.json'));

  syncedItemsJson['response']['data'].forEach((item) {
    tSyncedItemList.add(SyncedItemModel.fromJson(item));
  });

  group('getSyncedItems', () {
    test(
      'should call [getSyncedItems] from TautulliApi',
      () async {
        // arrange
        when(
          mockTautulliApi.getSyncedItems(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => syncedItemsJson);
        // act
        await dataSource.getSyncedItems(tautulliId: tTautulliId);
        // assert
        verify(
          mockTautulliApi.getSyncedItems(tautulliId: tTautulliId),
        );
      },
    );

    test(
      'should return a list of SyncedItemModel',
      () async {
        // arrange
        when(
          mockTautulliApi.getSyncedItems(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => syncedItemsJson);
        // act
        final result = await dataSource.getSyncedItems(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tSyncedItemList));
      },
    );
  });
}
