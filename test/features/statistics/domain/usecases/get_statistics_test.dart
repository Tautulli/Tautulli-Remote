import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/statistics/data/models/statistics_model.dart';
import 'package:tautulli_remote_tdd/features/statistics/domain/entities/statistics.dart';
import 'package:tautulli_remote_tdd/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:tautulli_remote_tdd/features/statistics/domain/usecases/get_statistics.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockStatisticsRepository extends Mock implements StatisticsRepository {}

void main() {
  GetStatistics usecase;
  MockStatisticsRepository mockStatisticsRepository;

  setUp(() {
    mockStatisticsRepository = MockStatisticsRepository();
    usecase = GetStatistics(
      repository: mockStatisticsRepository,
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

  test(
    'should return map of statistics with lists of StatisticsModel from repository',
    () async {
      // arrange
      when(
        mockStatisticsRepository.getStatistics(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          statsCount: anyNamed('statsCount'),
          statsType: anyNamed('statsType'),
          timeRange: anyNamed('timeRange'),
        ),
      ).thenAnswer((_) async => Right(tStatisticsMap));
      // act
      final result = await usecase(tautulliId: tTautulliId);
      // assert
      expect(result, equals(Right(tStatisticsMap)));
    },
  );
}
