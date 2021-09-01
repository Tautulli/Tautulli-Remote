// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/announcements/data/models/announcement_model.dart';
import 'package:tautulli_remote/features/announcements/domain/entities/announcement.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tAnnouncementModel = AnnouncementModel(
    id: 0,
    date: '2021-03-01',
    body: 'This is a test announcement.',
    title: 'Test Announcement',
    actionUrl: '',
  );

  test('should be a subclass of Announcement entity', () async {
    //assert
    expect(tAnnouncementModel, isA<Announcement>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final List jsonAnnouncementList =
            json.decode(fixture('announcements.json'));
        //act
        final result = AnnouncementModel.fromJson(jsonAnnouncementList[0]);
        //assert
        expect(result, tAnnouncementModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final List jsonAnnouncementList =
            json.decode(fixture('announcements.json'));
        // act
        final result = AnnouncementModel.fromJson(jsonAnnouncementList[0]);
        // assert
        expect(result.title, equals(jsonAnnouncementList[0]['title']));
      },
    );
  });
}
