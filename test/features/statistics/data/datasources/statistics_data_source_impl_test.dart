import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/statistics/data/datasources/statistics_data_source.dart';
import 'package:tautulli_remote/features/statistics/data/models/statistics_model.dart';
import 'package:tautulli_remote/features/statistics/domain/entities/statistics.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetHomeStats extends Mock implements tautulli_api.GetHomeStats {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  StatisticsDataSourceImpl dataSource;
  MockGetHomeStats mockApiGetHomeStats;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetHomeStats = MockGetHomeStats();
    dataSource = StatisticsDataSourceImpl(
      apiGetHomeStats: mockApiGetHomeStats,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';

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
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => statisticsJson);
        // act
        await dataSource.getStatistics(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockApiGetHomeStats(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ));
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
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => statisticsJson);
        // act
        final result = await dataSource.getStatistics(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tStatisticsMap));
      },
    );
  });
}
