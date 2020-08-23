import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/features/history/data/models/history_model.dart';
import 'package:tautulli_remote_tdd/features/history/domain/entities/history.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tHistoryModel = HistoryModel(
    id: 30354,
    date: 1597711452,
    started: 1597707297,
    stopped: 1597712741,
    duration: 1514,
    pausedCounter: 578,
    userId: 1,
    user: "user_name",
    friendlyName: "friendly_name",
    fullTitle: "F is for Family - Heavy Sledding",
    platform: "webOS",
    product: "Plex for LG",
    player: "LG OLED65C9PUA",
    ipAddress: "192.168.0.1",
    live: 0,
    mediaType: "episode",
    ratingKey: 98338,
    parentRatingKey: 98337,
    grandparentRatingKey: 98329,
    title: "Heavy Sledding",
    parentTitle: "Season 2",
    grandparentTitle: "F is for Family",
    year: 2017,
    mediaIndex: 1,
    parentMediaIndex: 2,
    thumb: "/library/metadata/98337/thumb/1591948561",
    transcodeDecision: "direct play",
    percentComplete: 96,
    watchedStatus: 1,
    groupCount: 3,
    groupIds: [30352, 30353, 30354],
    state: "playing",
    sessionKey: 1,
  );

  test('should be a subclass of History entity', () async {
    //assert
    expect(tHistoryModel, isA<History>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('history_item.json'));
        //act
        final result = HistoryModel.fromJson(jsonMap);
        //assert
        expect(result, tHistoryModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('history_item.json'));
        // act
        final result = HistoryModel.fromJson(jsonMap);
        // assert
        expect(result.id, equals(jsonMap['id']));
      },
    );
  });
}
