import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';
import 'package:tautulli_remote/features/synced_items/domain/repositories/synced_items_repository.dart';
import 'package:tautulli_remote/features/synced_items/domain/usecases/get_synced_items.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSyncedItemsRepository extends Mock implements SyncedItemsRepository {}

void main() {
  GetSyncedItems usecase;
  MockSyncedItemsRepository mockSyncedItemsRepository;

  setUp(() {
    mockSyncedItemsRepository = MockSyncedItemsRepository();
    usecase = GetSyncedItems(
      repository: mockSyncedItemsRepository,
    );
  });

  final tTautulliId = 'jkl';
  final List<SyncedItem> tSyncedItemsList = [];

  final syncedItemsJson = json.decode(fixture('synced_items.json'));

  syncedItemsJson['response']['data'].forEach((item) {
    tSyncedItemsList.add(SyncedItemModel.fromJson(item));
  });

  test(
    'should get list of SyncedItem from repository',
    () async {
      // arrange
      when(
        mockSyncedItemsRepository.getSyncedItems(
          tautulliId: anyNamed('tautulliId'),
        ),
      ).thenAnswer((_) async => Right(tSyncedItemsList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
      );
      // assert
      expect(result, equals(Right(tSyncedItemsList)));
    },
  );
}
