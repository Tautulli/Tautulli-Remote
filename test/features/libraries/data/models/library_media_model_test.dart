import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_media_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_media.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLibraryMediaModel = LibraryMediaModel(
    mediaIndex: 10,
    mediaType: 'episode',
    parentMediaIndex: 1,
    ratingKey: 77639,
    thumb: '/library/metadata/77639/thumb/1576284029',
    title: 'Leviathan Wakes',
    year: 2016,
  );

  test(
    'should be a subclass of LibraryMedia entity',
    () async {
      // assert
      expect(tLibraryMediaModel, isA<LibraryMedia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('library_media_item.json'));
        // act
        final result = LibraryMediaModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tLibraryMediaModel));
      },
    );

    test(
      'should return a LibraryMedia with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('library_media_item.json'));
        // act
        final result = LibraryMediaModel.fromJson(jsonMap);
        // assert
        expect(result.ratingKey, equals(int.tryParse(jsonMap['rating_key'])));
      },
    );
  });
}
