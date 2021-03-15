import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/statistics/data/models/statistics_model.dart';
import 'package:tautulli_remote/features/statistics/domain/entities/statistics.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTopTv = StatisticsModel(
    art: '/library/metadata/77725/art/1596182361',
    count: null,
    friendlyName: null,
    grandparentThumb: '/library/metadata/77725/thumb/1596182361',
    lastWatch: 1597622410,
    mediaType: 'episode',
    platform: null,
    ratingKey: 77725,
    rowId: 30343,
    sectionId: 1,
    statId: 'top_tv',
    thumb: '/library/metadata/77725/thumb/1596182361',
    title: 'The Umbrella Academy',
    totalDuration: 80763,
    totalPlays: 28,
    user: null,
    userId: null,
    usersWatched: null,
    userThumb: null,
  );

  final tPopularTv = StatisticsModel(
    art: '/library/metadata/1165/art/1598301159',
    count: null,
    friendlyName: null,
    grandparentThumb: '/library/metadata/1165/thumb/1598301159',
    lastWatch: 1598504156,
    mediaType: 'episode',
    platform: null,
    ratingKey: 1165,
    rowId: 30471,
    sectionId: 1,
    statId: 'popular_tv',
    thumb: '/library/metadata/1165/thumb/1598301159',
    title: "Marvel's Agents of S.H.I.E.L.D.",
    totalDuration: null,
    totalPlays: 17,
    user: null,
    userId: null,
    usersWatched: 5,
    userThumb: null,
  );

  final tTopMovies = StatisticsModel(
    art: '/library/metadata/99915/art/1597430953',
    count: null,
    friendlyName: null,
    grandparentThumb: null,
    lastWatch: 1597535322,
    mediaType: 'movie',
    platform: null,
    ratingKey: 99915,
    rowId: 30326,
    sectionId: 12,
    statId: 'top_movies',
    thumb: '/library/metadata/99915/thumb/1597430953',
    title: 'The King of Staten Island',
    totalDuration: 16222,
    totalPlays: 2,
    user: null,
    userId: null,
    usersWatched: null,
    userThumb: null,
  );

  final tPopularMovies = StatisticsModel(
    art: '/library/metadata/99915/art/1597430953',
    count: null,
    friendlyName: null,
    grandparentThumb: null,
    lastWatch: 1597535322,
    mediaType: 'movie',
    platform: null,
    ratingKey: 99915,
    rowId: 30326,
    sectionId: 12,
    statId: 'popular_movies',
    thumb: '/library/metadata/99915/thumb/1597430953',
    title: "The King of Staten Island",
    totalDuration: null,
    totalPlays: 2,
    user: null,
    userId: null,
    usersWatched: 2,
    userThumb: null,
  );

  final tTopMusic = StatisticsModel(
    art: '/library/metadata/112694/art/1597994442',
    count: null,
    friendlyName: null,
    grandparentThumb: '/library/metadata/112694/thumb/1597994442',
    lastWatch: 1598393262,
    mediaType: 'track',
    platform: null,
    ratingKey: 112694,
    rowId: 42454,
    sectionId: 27,
    statId: 'top_music',
    thumb: '/library/metadata/112694/thumb/1597994442',
    title: 'Alvvays',
    totalDuration: 3452,
    totalPlays: 14,
    user: null,
    userId: null,
    usersWatched: null,
    userThumb: null,
  );

  final tPopularMusic = StatisticsModel(
    art: '/library/metadata/81222/art/1597825585',
    count: null,
    friendlyName: null,
    grandparentThumb: '/library/metadata/81222/thumb/1597825585',
    lastWatch: 1598220506,
    mediaType: 'track',
    platform: null,
    ratingKey: 81222,
    rowId: 42359,
    sectionId: 32,
    statId: 'popular_music',
    thumb: '/library/metadata/81222/thumb/1597825585',
    title: "Looking Glass",
    totalDuration: null,
    totalPlays: 2,
    user: null,
    userId: null,
    usersWatched: 1,
    userThumb: null,
  );

  final tLastWatched = StatisticsModel(
    art: '/library/metadata/1165/art/1598301159',
    count: null,
    friendlyName: 'Friendly Name',
    grandparentThumb: '/library/metadata/1165/thumb/1598301159',
    lastWatch: 1598504156,
    mediaType: 'episode',
    platform: null,
    ratingKey: 99114,
    rowId: 30471,
    sectionId: 1,
    statId: 'last_watched',
    thumb: '/library/metadata/1165/thumb/1598301159',
    title: "Marvel's Agents of S.H.I.E.L.D. - Out of the Past",
    totalDuration: null,
    totalPlays: null,
    user: 'user',
    userId: 7103291,
    usersWatched: null,
    userThumb: 'https://plex.tv/users/2b69a9a9bdc35745/avatar?c=1576702730',
  );

  final tTopPlatforms = StatisticsModel(
    count: null,
    friendlyName: null,
    grandparentThumb: null,
    lastWatch: 1598500259,
    platform: 'Chrome',
    platformName: 'chrome',
    ratingKey: null,
    rowId: null,
    sectionId: null,
    statId: 'top_platforms',
    thumb: null,
    title: null,
    totalDuration: 174839,
    totalPlays: 86,
    user: null,
    userId: null,
    usersWatched: null,
    userThumb: null,
  );

  final tTopUsers = StatisticsModel(
    count: null,
    friendlyName: 'Friendly Name',
    grandparentThumb: null,
    lastWatch: 1598401028,
    platform: null,
    ratingKey: null,
    rowId: null,
    sectionId: null,
    statId: 'top_users',
    thumb: null,
    title: null,
    totalDuration: 130140,
    totalPlays: 52,
    user: 'user',
    userId: 1526265,
    usersWatched: null,
    userThumb: 'https://plex.tv/users/5df7320378672025/avatar?c=1578073887',
  );

  final tMostConcurrent = StatisticsModel(
    count: 4,
    friendlyName: null,
    grandparentThumb: null,
    lastWatch: null,
    platform: null,
    ratingKey: null,
    rowId: null,
    sectionId: null,
    started: 1596333509,
    statId: 'most_concurrent',
    thumb: null,
    title: 'Concurrent Streams',
    totalDuration: null,
    totalPlays: null,
    user: null,
    userId: null,
    usersWatched: null,
    userThumb: null,
  );

  final tTopLibraries = StatisticsModel(
    art: '/:/resources/show-fanart.jpg',
    lastWatch: null,
    sectionId: 1,
    sectionName: 'TV Shows',
    sectionType: 'show',
    statId: 'top_libraries',
    thumb: '/:/resources/show.png',
    totalDuration: 1734237,
    totalPlays: 879,
  );

  test('should be a subclass of Statistics entity', () async {
    //assert
    expect(tTopTv, isA<Statistics>());
    expect(tPopularTv, isA<Statistics>());
    expect(tTopMovies, isA<Statistics>());
    expect(tPopularMovies, isA<Statistics>());
    expect(tTopMusic, isA<Statistics>());
    expect(tPopularMusic, isA<Statistics>());
    expect(tLastWatched, isA<Statistics>());
    expect(tTopPlatforms, isA<Statistics>());
    expect(tTopUsers, isA<Statistics>());
    expect(tMostConcurrent, isA<Statistics>());
    expect(tTopLibraries, isA<Statistics>());
  });

  group('fromJson', () {
    test(
      'should return a valid model for Top TV',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_top_tv_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'top_tv',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tTopTv));
      },
    );

    test(
      'should return a valid model for Popular TV',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_popular_tv_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'popular_tv',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tPopularTv));
      },
    );

    test(
      'should return a valid model for Top Movies',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_top_movies_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'top_movies',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tTopMovies));
      },
    );

    test(
      'should return a valid model for Popular Movies',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_popular_movies_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'popular_movies',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tPopularMovies));
      },
    );

    test(
      'should return a valid model for Top Music',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_top_music_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'top_music',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tTopMusic));
      },
    );

    test(
      'should return a valid model for Popular Music',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_popular_music_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'popular_music',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tPopularMusic));
      },
    );

    test(
      'should return a valid model for Last Watched',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_last_watched_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'last_watched',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tLastWatched));
      },
    );

    test(
      'should return a valid model for Top Platforms',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_top_platforms_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'top_platforms',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tTopPlatforms));
      },
    );

    test(
      'should return a valid model for Top Users',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_top_users_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'top_users',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tTopUsers));
      },
    );

    test(
      'should return a valid model for Most Concurrent',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_most_concurrent_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'most_concurrent',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tMostConcurrent));
      },
    );

    test(
      'should return a valid model for Top Libraries',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('statistics_top_libraries_item.json'));
        // act
        final result = StatisticsModel.fromJson(
          statId: 'top_libraries',
          json: jsonMap,
        );
        // assert
        expect(result, equals(tTopLibraries));
      },
    );
  });
}
