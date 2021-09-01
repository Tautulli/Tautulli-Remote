// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/synced_items/data/models/synced_item_model.dart';
import 'package:tautulli_remote/features/synced_items/domain/entities/synced_item.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tSyncedItemModel = SyncedItemModel(
    clientId: 'abc-com-plexapp-android',
    deviceName: 'OnePlus 7T',
    itemCompleteCount: 6,
    mediaType: 'episode',
    platform: 'Android',
    ratingKey: 79077,
    rootTitle: 'TV Shows',
    state: 'complete',
    syncId: 4555376,
    syncTitle: 'Good Omens',
    totalSize: 6781439736,
    user: 'Derek Rivard',
    userId: 152626,
    username: 'TheMeanCanEHdian',
    videoQuality: 100,
    multipleRatingKeys: false,
  );

  test('should be a subclass of SyncedItem entity', () async {
    //assert
    expect(tSyncedItemModel, isA<SyncedItem>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('synced_item.json'));
        // act
        final result = SyncedItemModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tSyncedItemModel));
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('synced_item.json'));
        // act
        final result = SyncedItemModel.fromJson(jsonMap);
        // assert
        expect(result.userId, equals(int.tryParse(jsonMap['user_id'])));
      },
    );
  });
}
