import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/api/tautulli_api.dart';
import 'package:tautulli_remote_tdd/features/history/data/datasources/history_data_source.dart';
import 'package:tautulli_remote_tdd/features/history/data/models/history_model.dart';
import 'package:tautulli_remote_tdd/features/history/domain/entities/history.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

class MockLogging extends Mock implements Logging {}

void main() {
  HistoryDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;
  MockLogging mockLogging;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    mockLogging = MockLogging();
    dataSource = HistoryDataSourceImpl(
      tautulliApi: mockTautulliApi,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';

  final List<History> tHistoryList = [];

  final historyJson = json.decode(fixture('history.json'));

  historyJson['response']['data']['data'].forEach((item) {
    if (item['state'] == null) {
      tHistoryList.add(HistoryModel.fromJson(item));
    }
  });

  group('getHistory', () {
    test(
      'should call [getHistory] from TautulliApi',
      () async {
        // arrange
        when(mockTautulliApi.getHistory(
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
        )).thenAnswer((_) async => historyJson);
        // act
        await dataSource.getHistory(tautulliId: tTautulliId);
        // assert
        verify(mockTautulliApi.getHistory(tautulliId: tTautulliId));
      },
    );

    test(
      'should return list of HistoryModel',
      () async {
        // arrange
        when(mockTautulliApi.getHistory(
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
        )).thenAnswer((_) async => historyJson);
        // act
        final result = await dataSource.getHistory(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tHistoryList));
      },
    );
  });
}
