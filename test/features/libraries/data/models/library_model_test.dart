import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLibraryModel = LibraryModel(
    childCount: 25214,
    count: 427,
    duration: 38085486,
    isActive: 1,
    lastAccessed: 1600751837,
    libraryArt: '/:/resources/show-fanart.jpg',
    libraryThumb: '/:/resources/show.png',
    parentCount: 1561,
    plays: 20299,
    sectionId: 1,
    sectionName: 'TV Shows',
    sectionType: 'show',
  );

  test('should be a subclass of Library entity', () async {
    //assert
    expect(tLibraryModel, isA<Library>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('library_item.json'));
        //act
        final result = LibraryModel.fromJson(jsonMap);
        //assert
        expect(result, tLibraryModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('library_item.json'));
        // act
        final result = LibraryModel.fromJson(jsonMap);
        // assert
        expect(result.sectionId, equals(jsonMap['section_id']));
      },
    );
  });
}
