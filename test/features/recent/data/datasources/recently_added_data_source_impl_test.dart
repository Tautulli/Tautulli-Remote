import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/recent/data/datasources/recently_added_data_source.dart';
import 'package:tautulli_remote/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote/features/recent/domain/entities/recent.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

class MockLogging extends Mock implements Logging {}

void main() {
  RecentlyAddedDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;
  MockLogging mockLogging;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    mockLogging = MockLogging();
    dataSource = RecentlyAddedDataSourceImpl(
        tautulliApi: mockTautulliApi, logging: mockLogging);
  });

  final String tTautulliId = 'jkl';
  final int tCount = 10;

  final List<RecentItem> tRecentList = [];

  final recentJson = json.decode(fixture('recent.json'));

  recentJson['response']['data']['recently_added'].forEach((item) {
    tRecentList.add(RecentItemModel.fromJson(item));
  });

  group('getRecentlyAdded', () {
    test(
      'should call [getRecentActivty] from TautulliApi',
      () async {
        // arrange
        when(
          mockTautulliApi.getRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
          ),
        ).thenAnswer((_) async => recentJson);
        // act
        await dataSource.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
        );
        // assert
        verify(mockTautulliApi.getRecentlyAdded(
            tautulliId: tTautulliId, count: tCount));
      },
    );

    test(
      'should return list of RecentItemModel',
      () async {
        // arrange
        when(
          mockTautulliApi.getRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
          ),
        ).thenAnswer((_) async => recentJson);
        // act
        final result = await dataSource.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
        );
        // assert
        expect(result, equals(tRecentList));
      },
    );
  });
}
