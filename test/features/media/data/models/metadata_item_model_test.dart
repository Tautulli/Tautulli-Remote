import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMetadataItemModel = MetadataItemModel(
    grandparentRatingKey: null,
    grandparentThumb: null,
    parentRatingKey: null,
    parentThumb: null,
    ratingKey: 53052,
    thumb: '/library/metadata/53052/thumb/1599764717',
  );

  test('should be a subclass of MetadataItem entity', () async {
    //assert
    expect(tMetadataItemModel, isA<MetadataItem>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('metadata_item.json'));
        // act
        final result = MetadataItemModel.fromJson(jsonMap['response']['data']);
        // assert
        expect(result, equals(tMetadataItemModel));
      },
    );

    test(
      'should return a MetadataItem with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('metadata_item.json'));
        // act
        final result = MetadataItemModel.fromJson(jsonMap['response']['data']);
        // assert
        expect(result.ratingKey,
            equals(int.tryParse(jsonMap['response']['data']['rating_key'])));
      },
    );
  });
}
