import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/statistics/data/datasources/statistics_data_source.dart';
import 'package:tautulli_remote/features/statistics/data/models/statistics_model.dart';
import 'package:tautulli_remote/features/statistics/domain/entities/statistics.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetHomeStats extends Mock implements tautulliApi.GetHomeStats {}

void main() {
  StatisticsDataSourceImpl dataSource;
  MockGetHomeStats mockApiGetHomeStats;

  setUp(() {
    mockApiGetHomeStats = MockGetHomeStats();
    dataSource = StatisticsDataSourceImpl(
      apiGetHomeStats: mockApiGetHomeStats,
    );
  });

  final String tTautulliId = 'jkl';

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

  group('getStatistics', () {
    test(
      'should call [getHomeStats] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetHomeStats(
            tautulliId: anyNamed('tautulliId'),
            grouping: anyNamed('grouping'),
            statsCount: anyNamed('statsCount'),
            statsType: anyNamed('statsType'),
            timeRange: anyNamed('timeRange'),
          ),
        ).thenAnswer((_) async => statisticsJson);
        // act
        await dataSource.getStatistics(tautulliId: tTautulliId);
        // assert
        verify(mockApiGetHomeStats(tautulliId: tTautulliId));
      },
    );

    test(
      'should return map of statistics with lists of StatisticsModel',
      () async {
        // arrange
        when(
          mockApiGetHomeStats(
            tautulliId: anyNamed('tautulliId'),
            grouping: anyNamed('grouping'),
            statsCount: anyNamed('statsCount'),
            statsType: anyNamed('statsType'),
            timeRange: anyNamed('timeRange'),
          ),
        ).thenAnswer((_) async => statisticsJson);
        // act
        final result = await dataSource.getStatistics(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tStatisticsMap));
      },
    );
  });
}
