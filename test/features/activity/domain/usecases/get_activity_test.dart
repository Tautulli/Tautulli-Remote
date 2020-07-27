import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

  final Map<String, Map<String, Object>> tActivityMap = {
    'Plex': {
      'result': 'success',
      'activity': []
    }
  };

  test(
    'should get Activity from API',
    () async {
      // arrange
      when(mockActivityRepository.getActivity())
          .thenAnswer((_) async => Right(tActivityMap));
      //act
      final result = await usecase();
      //assert
      expect(result, Right(tActivityMap));
      verify(mockActivityRepository.getActivity());
      verifyNoMoreInteractions(mockActivityRepository);
    },
  );
}
