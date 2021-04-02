import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_statistic_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_statistic.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLibraryWatchTimeStat = LibraryStatisticModel(
    libraryStatisticType: LibraryStatisticType.watchTime,
    queryDays: 1,
    totalTime: 22976,
    totalPlays: 16,
  );

  final tLibraryUserStat = LibraryStatisticModel(
    libraryStatisticType: LibraryStatisticType.user,
    friendlyName: 'Friendly Name',
    userId: 1526265,
    userThumb: 'https://plex.tv/users/5df7320378672025/avatar',
    username: 'username',
    totalPlays: 3944,
  );

  group('Watch Time Statistic', () {
    test('should be a subclass of LibraryStatistic entity', () async {
      //assert
      expect(tLibraryWatchTimeStat, isA<LibraryStatistic>());
    });

    group('fromJson', () {
      test(
        'should return a valid model',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('library_watch_time_stat_item.json'));
          // act
          final result = LibraryStatisticModel.fromJson(
            libraryStatisticType: LibraryStatisticType.watchTime,
            json: jsonMap,
          );
          // assert
          expect(result, equals(tLibraryWatchTimeStat));
        },
      );

      test(
        'should return an item with properly mapped data',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('library_watch_time_stat_item.json'));
          // act
          final result = LibraryStatisticModel.fromJson(
            libraryStatisticType: LibraryStatisticType.watchTime,
            json: jsonMap,
          );
          // assert
          expect(result.totalTime, equals(jsonMap['total_time']));
        },
      );
    });
  });

  group('User Statistic', () {
    test('should be a subclass ofLibraryStatistic entity', () async {
      //assert
      expect(tLibraryUserStat, isA<LibraryStatistic>());
    });

    group('fromJson', () {
      test(
        'should return a valid model',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('library_user_stat_item.json'));
          // act
          final result = LibraryStatisticModel.fromJson(
            libraryStatisticType: LibraryStatisticType.user,
            json: jsonMap,
          );
          // assert
          expect(result, equals(tLibraryUserStat));
        },
      );

      test(
        'should return an item with properly mapped data',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('library_user_stat_item.json'));
          // act
          final result = LibraryStatisticModel.fromJson(
            libraryStatisticType: LibraryStatisticType.user,
            json: jsonMap,
          );
          // assert
          expect(result.userId, equals(jsonMap['user_id']));
        },
      );
    });
  });
}
