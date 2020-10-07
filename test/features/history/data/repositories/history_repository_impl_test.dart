import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/history/data/datasources/history_data_source.dart';
import 'package:tautulli_remote_tdd/features/history/data/models/history_model.dart';
import 'package:tautulli_remote_tdd/features/history/data/repositories/history_repository_impl.dart';
import 'package:tautulli_remote_tdd/features/history/domain/entities/history.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHistoryDataSource extends Mock implements HistoryDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  HistoryRepositoryImpl repository;
  MockHistoryDataSource mockHistoryDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockHistoryDataSource = MockHistoryDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = HistoryRepositoryImpl(
      dataSource: mockHistoryDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final String tTautulliId = 'jkl';

  final List<History> tHistoryList = [];

  final historyJson = json.decode(fixture('history.json'));

  historyJson['response']['data']['data'].forEach((item) {
    tHistoryList.add(HistoryModel.fromJson(item));
  });

  test(
    'should check if device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getHistory(tautulliId: tTautulliId);
      // assert
      verify(mockNetworkInfo.isConnected);
    },
  );

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should call the data source getHistory()',
      () async {
        // act
        await repository.getHistory(tautulliId: tTautulliId);
        // assert
        verify(
          mockHistoryDataSource.getHistory(tautulliId: tTautulliId),
        );
      },
    );

    test(
      'should return list of History when call to API is successful',
      () async {
        // arrange
        when(
          mockHistoryDataSource.getHistory(
            tautulliId: tTautulliId,
            grouping: anyNamed('grouping'),
            user: anyNamed('user'),
            userId: anyNamed('userId'),
            ratingKey: anyNamed('ratingKey'),
            parentRatingKey: anyNamed('parentRatingKey'),
            grandparentRatingKey: anyNamed('grandparentRatingKey'),
            startDate: anyNamed('startDate'),
            sectionId: anyNamed('sectionId'),
            mediaType: anyNamed('mediaType'),
            transcodeDecision: anyNamed('transcodeDecision'),
            guid: anyNamed('guid'),
            orderColumn: anyNamed('orderColumn'),
            orderDir: anyNamed('orderDir'),
            start: anyNamed('start'),
            length: anyNamed('length'),
            search: anyNamed('search'),
          ),
        ).thenAnswer((_) async => tHistoryList);
        // act
        final result = await repository.getHistory(tautulliId: tTautulliId);
        // assert
        expect(result, equals(Right(tHistoryList)));
      },
    );
  });

  group('device is offline', () {
    test(
      'should return a ConnectionFailure when there is no network connection',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // act
        final result = await repository.getHistory(tautulliId: tTautulliId);
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
