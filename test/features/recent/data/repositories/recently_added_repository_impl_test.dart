import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/recent/data/datasources/recently_added_data_source.dart';
import 'package:tautulli_remote_tdd/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote_tdd/features/recent/data/repositories/recently_added_repository_impl.dart';
import 'package:tautulli_remote_tdd/features/recent/domain/entities/recent.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRecentlyAddedDataSource extends Mock
    implements RecentlyAddedDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  RecentlyAddedRepositoryImpl repository;
  MockRecentlyAddedDataSource mockRecentlyAddedDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRecentlyAddedDataSource = MockRecentlyAddedDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RecentlyAddedRepositoryImpl(
      dataSource: mockRecentlyAddedDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final String tTautulliId = 'jkl';
  final int tCount = 10;

  final List<RecentItem> tRecentList = [];

  final recentJson = json.decode(fixture('recent.json'));

  recentJson['response']['data']['recently_added'].forEach((item) {
    tRecentList.add(RecentItemModel.fromJson(item));
  });

  test(
    'should check if device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRecentlyAdded(
        tautulliId: tTautulliId,
        count: tCount,
      );
      // assert
      verify(mockNetworkInfo.isConnected);
    },
  );

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should call the data source getRecentlyAdded()',
      () async {
        // act
        await repository.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
        );
        // assert
        verify(
          mockRecentlyAddedDataSource.getRecentlyAdded(
            tautulliId: tTautulliId,
            count: tCount,
          ),
        );
      },
    );

    test(
      'should return list of RecentItem when call to API is successful',
      () async {
        // arrange
        when(
          mockRecentlyAddedDataSource.getRecentlyAdded(
            tautulliId: anyNamed('tautulliId'),
            count: anyNamed('count'),
            start: anyNamed('start'),
            mediaType: anyNamed('mediaType'),
            sectionId: anyNamed('sectionId'),
          ),
        ).thenAnswer((_) async => tRecentList);
        // act
        final result = await repository.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
        );
        // assert
        expect(result, equals(Right(tRecentList)));
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
         final result = await repository.getRecentlyAdded(
          tautulliId: tTautulliId,
          count: tCount,
        );
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
