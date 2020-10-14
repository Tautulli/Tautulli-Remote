import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/recent/data/models/recent_model.dart';
import 'package:tautulli_remote/features/recent/domain/entities/recent.dart';
import 'package:tautulli_remote/features/recent/domain/repositories/recently_added_repository.dart';
import 'package:tautulli_remote/features/recent/domain/usecases/get_recently_added.dart';

import '../../../fixtures/fixture_reader.dart';

class MockRecentlyAddedRepository extends Mock
    implements RecentlyAddedRepository {}

void main() {
  GetRecentlyAdded usecase;
  MockRecentlyAddedRepository mockRecentlyAddedRepository;

  setUp(() {
    mockRecentlyAddedRepository = MockRecentlyAddedRepository();
    usecase = GetRecentlyAdded(
      repository: mockRecentlyAddedRepository,
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
    'should get list of RecentItem from repository',
    () async {
      // arrange
      when(
        mockRecentlyAddedRepository.getRecentlyAdded(
          tautulliId: anyNamed('tautulliId'),
          count: anyNamed('count'),
          start: anyNamed('start'),
          mediaType: anyNamed('mediaType'),
          sectionId: anyNamed('sectionId'),
        ),
      ).thenAnswer((_) async => Right(tRecentList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        count: tCount,
      );
      // assert
      expect(result, equals(Right(tRecentList)));
    },
  );
}
