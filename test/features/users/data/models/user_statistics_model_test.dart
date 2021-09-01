// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/users/data/models/user_statistic_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_statistic.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserWatchTimeStat = UserStatisticModel(
    userStatisticType: UserStatisticType.watchTime,
    queryDays: 30,
    totalTime: 27232,
    totalPlays: 14,
  );

  final tUserPlayerStat = UserStatisticModel(
    userStatisticType: UserStatisticType.player,
    playerName: 'BRAVIA 4K 2015',
    platform: 'Android',
    platformName: 'android',
    totalPlays: 1270,
    resultId: 0,
  );

  group('Watch Time Statistic', () {
    test('should be a subclass of UserStatistic entity', () async {
      //assert
      expect(tUserWatchTimeStat, isA<UserStatistic>());
    });

    group('fromJson', () {
      test(
        'should return a valid model',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_watch_time_stat_item.json'));
          // act
          final result = UserStatisticModel.fromJson(
            userStatisticType: UserStatisticType.watchTime,
            json: jsonMap,
          );
          // assert
          expect(result, equals(tUserWatchTimeStat));
        },
      );

      test(
        'should return an item with properly mapped data',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_watch_time_stat_item.json'));
          // act
          final result = UserStatisticModel.fromJson(
            userStatisticType: UserStatisticType.watchTime,
            json: jsonMap,
          );
          // assert
          expect(result.totalTime, equals(jsonMap['total_time']));
        },
      );
    });
  });

  group('Player Statistic', () {
    test('should be a subclass of UserStatistic entity', () async {
      //assert
      expect(tUserPlayerStat, isA<UserStatistic>());
    });

    group('fromJson', () {
      test(
        'should return a valid model',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_player_stat_item.json'));
          // act
          final result = UserStatisticModel.fromJson(
            userStatisticType: UserStatisticType.player,
            json: jsonMap,
          );
          // assert
          expect(result, equals(tUserPlayerStat));
        },
      );

      test(
        'should return an item with properly mapped data',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_player_stat_item.json'));
          // act
          final result = UserStatisticModel.fromJson(
            userStatisticType: UserStatisticType.player,
            json: jsonMap,
          );
          // assert
          expect(result.playerName, equals(jsonMap['player_name']));
        },
      );
    });
  });
}
