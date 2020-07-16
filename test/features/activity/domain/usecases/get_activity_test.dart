import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/activity_model.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/repositories/activity_repository.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/usecases/get_activity.dart';

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

  final List<ActivityItem> tActivity = [
    ActivityItemModel(
      sessionKey: 25,
    ),
  ];

  test(
    'should get Activity from API',
    () async {
      // arrange
      when(mockActivityRepository.getActivity())
          .thenAnswer((_) async => Right(tActivity));
      //act
      final result = await usecase();
      //assert
      expect(result, Right(tActivity));
      verify(mockActivityRepository.getActivity());
      verifyNoMoreInteractions(mockActivityRepository);
    },
  );
}
