import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/features/libraries/data/models/library_model.dart';
import 'package:tautulli_remote_tdd/features/libraries/domain/entities/library.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLibraryModel = LibraryModel(
    agent: 'com.plexapp.agents.thetvdb',
    art: '/:/resources/show-fanart.jpg',
    childCount: 100,
    count: 20,
    isActive: 1,
    parentCount: 60,
    sectionId: 1,
    sectionName: 'TV Shows',
    sectionType: 'show',
    thumb: '/:/resources/show.png',
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
        expect(result.sectionId, equals(int.tryParse(jsonMap['section_id'])));
      },
    );
  });
}
