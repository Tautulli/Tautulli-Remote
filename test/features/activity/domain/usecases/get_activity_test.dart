import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/activity/data/models/activity_model.dart';
import 'package:tautulli_remote/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote/features/activity/domain/repositories/activity_repository.dart';
import 'package:tautulli_remote/features/activity/domain/usecases/get_activity.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  GetActivity usecase;
  MockActivityRepository mockActivityRepository;

  setUp(() {
    mockActivityRepository = MockActivityRepository();
    usecase = GetActivity(
      repository: mockActivityRepository
    );
  });

  final tTautulliId = 'abc';

  final tActivityJson = json.decode(fixture('activity.json'));

  List<ActivityItem> tActivityList = [];
  tActivityJson['response']['data']['sessions'].forEach(
    (session) {
      tActivityList.add(
        ActivityItemModel.fromJson(session),
      );
    },
  );
   test(
    'should get Activity from API',
    () async {
      // arrange
      when(mockActivityRepository.getActivity(tautulliId: tTautulliId))
          .thenAnswer((_) async => Right(tActivityList));
      //act
      final result = await usecase(tautulliId: tTautulliId);
      //assert
      expect(result, Right(tActivityList));
      verify(mockActivityRepository.getActivity(tautulliId: tTautulliId));
      verifyNoMoreInteractions(mockActivityRepository);
    },
  );
}
