import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote/features/recent/domain/entities/recent.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tRecentItemModel = RecentItemModel(
    addedAt: 1596698687,
    art: '/library/metadata/77631/art/1596698994',
    grandparentRatingKey: 77631,
    grandparentThumb: '/library/metadata/77631/thumb/1596698994',
    grandparentTitle: 'Doom Patrol',
    libraryName: 'TV Shows',
    mediaIndex: 9,
    mediaType: 'episode',
    parentMediaIndex: 2,
    parentRatingKey: 99302,
    parentThumb: '/library/metadata/99302/thumb/1596698994',
    parentTitle: 'Season 2',
    ratingKey: 99886,
    sectionId: 1,
    thumb: '/library/metadata/99886/thumb/1596699628',
    title: 'Wax Patrol',
    year: 2020,
  );

  test('should be a subclass of RecentItem entity', () async {
    //assert
    expect(tRecentItemModel, isA<RecentItem>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('recent_item.json'));
        // act
        final result = RecentItemModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tRecentItemModel));
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('recent_item.json'));
        // act
        final result = RecentItemModel.fromJson(jsonMap);
        // assert
        expect(result.title, equals(jsonMap['title']));
      },
    );
  });
}
