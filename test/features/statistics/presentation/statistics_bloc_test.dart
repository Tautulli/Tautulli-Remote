import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/statistics/data/models/statistics_model.dart';
import 'package:tautulli_remote/features/statistics/domain/entities/statistics.dart';
import 'package:tautulli_remote/features/statistics/domain/usecases/get_statistics.dart';
import 'package:tautulli_remote/features/statistics/presentation/bloc/statistics_bloc.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetStatistics extends Mock implements GetStatistics {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  StatisticsBloc bloc;
  MockGetStatistics mockGetStatistics;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetStatistics = MockGetStatistics();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
    bloc = StatisticsBloc(
      getStatistics: mockGetStatistics,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final int tGrouping = 1;
  final int tTimeRange = 30;
  final String tStatsType = 'plays';
  final int tStatsCount = 5;

  final statisticsJson = json.decode(fixture('statistics.json'));
  Map<String, List<Statistics>> tStatisticsMap = {
    'top_tv': [],
    'popular_tv': [],
    'top_movies': [],
    'popular_movies': [],
    'top_music': [],
    'popular_music': [],
    'last_watched': [],
    'top_platforms': [],
    'top_users': [],
    'most_concurrent': [],
    'top_libraries': [],
  };

  // Map<String, bool> tHasReachedMaxMap = {
  //   'top_tv': false,
  //   'popular_tv': false,
  //   'top_movies': false,
  //   'popular_movies': false,
  //   'top_music': false,
  //   'popular_music': false,
  //   'last_watched': false,
  //   'top_platforms': false,
  //   'top_users': false,
  //   'most_concurrent': false,
  // };

  statisticsJson['response']['data'].forEach((statistic) {
    statistic['rows'].forEach((item) {
      tStatisticsMap[statistic['stat_id']].add(
        StatisticsModel.fromJson(
          statId: statistic['stat_id'],
          json: item,
        ),
      );
    });
  });

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      mockGetStatistics(
        tautulliId: anyNamed('tautulliId'),
        grouping: anyNamed('grouping'),
        statsCount: anyNamed('statsCount'),
        statsType: anyNamed('statsType'),
        timeRange: anyNamed('timeRange'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(tStatisticsMap));
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
  }

  test(
    'initialState should be StatisticsInitial',
    () async {
      // assert
      expect(bloc.state, StatisticsInitial());
    },
  );

  group('StatisticsFetch', () {
    test(
      'should get data from GetStatistics use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(StatisticsFetch(
          tautulliId: tTautulliId,
          grouping: tGrouping,
          statsCount: tStatsCount,
          statsType: tStatsType,
          timeRange: tTimeRange,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(
          mockGetStatistics(
            tautulliId: anyNamed('tautulliId'),
            grouping: anyNamed('grouping'),
            statsCount: anyNamed('statsCount'),
            statsType: anyNamed('statsType'),
            timeRange: anyNamed('timeRange'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(
          mockGetStatistics(
            tautulliId: tTautulliId,
            grouping: tGrouping,
            statsCount: tStatsCount,
            statsType: tStatsType,
            timeRange: tTimeRange,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );
  });

  test(
    'should get data from the GetImageUrl use case',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // act
      bloc.add(
        StatisticsFetch(
          tautulliId: tTautulliId,
          grouping: tGrouping,
          statsCount: tStatsCount,
          statsType: tStatsType,
          timeRange: tTimeRange,
          settingsBloc: settingsBloc,
        ),
      );
      await untilCalled(
        mockGetImageUrl(
          tautulliId: anyNamed('tautulliId'),
          img: anyNamed('img'),
          ratingKey: anyNamed('ratingKey'),
          fallback: anyNamed('fallback'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      );
      // assert
      verify(
        mockGetImageUrl(
          tautulliId: anyNamed('tautulliId'),
          img: anyNamed('img'),
          ratingKey: anyNamed('ratingKey'),
          fallback: anyNamed('fallback'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      );
    },
  );

  // test(
  //   'should emit [StatisticsSuccess] with noStats as false when data is fetched successfully and stats are present',
  //   () async {
  //     // arrange
  //     setUpSuccess();
  //     clearCache();
  //     // assert later
  //     final expected = [
  //       StatisticsSuccess(
  //         map: tStatisticsMap,
  //         noStats: false,
  //         hasReachedMaxMap: tHasReachedMaxMap,
  //         lastUpdated: DateTime.now(),
  //       ),
  //     ];
  //     expectLater(bloc, emitsInOrder(expected));
  //     // act
  //     bloc.add(
  //       StatisticsFetch(
  //         tautulliId: tTautulliId,
  //         grouping: tGrouping,
  //         statsCount: tStatsCount,
  //         statsType: tStatsType,
  //         timeRange: tTimeRange,
  //       ),
  //     );
  //   },
  // );

  // test(
  //   'should emit [StatisticsSuccess] with noStats as true when data is fetched successfully and there are no stats',
  //   () async {
  //     // arrange
  //     setUpSuccess();
  //     clearCache();
  //     // assert later
  //     final expected = [
  //       StatisticsSuccess(
  //         map: tStatisticsMap,
  //         noStats: true,
  //         hasReachedMaxMap: tHasReachedMaxMap,
  //         lastUpdated: DateTime.now(),
  //       ),
  //     ];
  //     expectLater(bloc, emitsInOrder(expected));
  //     // act
  //     bloc.add(
  //       StatisticsFetch(
  //         tautulliId: tTautulliId,
  //         grouping: tGrouping,
  //         statsCount: tStatsCount,
  //         statsType: tStatsType,
  //         timeRange: tTimeRange,
  //       ),
  //     );
  //   },
  // );

  test(
    'should emit [StatisticsFailure] with a proper message when getting data fails',
    () async {
      // arrange
      final failure = ServerFailure();
      clearCache();
      when(
        mockGetStatistics(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          statsCount: anyNamed('statsCount'),
          statsType: anyNamed('statsType'),
          timeRange: anyNamed('timeRange'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Left(failure));
      // assert later
      final expected = [
        StatisticsFailure(
          failure: failure,
          message: SERVER_FAILURE_MESSAGE,
          suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
        StatisticsFetch(
          tautulliId: tTautulliId,
          grouping: tGrouping,
          statsCount: tStatsCount,
          statsType: tStatsType,
          timeRange: tTimeRange,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );

  // group('StatisticsFilter', () {
  //   test(
  //     'should emit [StatisticsInitial] before executing as normal',
  //     () async {
  //       // arrange
  //       setUpSuccess();
  //       clearCache();
  //       // assert later
  //       final expected = [
  //         StatisticsInitial(),
  //         StatisticsSuccess(
  //           map: tStatisticsMap,
  //           noStats: false,
  //           hasReachedMaxMap: tHasReachedMaxMap,
  //           lastUpdated: DateTime.now(),
  //         ),
  //       ];
  //       expectLater(bloc, emitsInOrder(expected));
  //       // act
  //       bloc.add(
  //         StatisticsFilter(
  //           tautulliId: tTautulliId,
  //           grouping: tGrouping,
  //           statsCount: tStatsCount,
  //           statsType: tStatsType,
  //           timeRange: tTimeRange,
  //         ),
  //       );
  //     },
  //   );
  // });
}
