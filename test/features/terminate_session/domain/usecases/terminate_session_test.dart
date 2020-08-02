import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/terminate_session/domain/repositories/terminate_session_repository.dart';
import 'package:tautulli_remote_tdd/features/terminate_session/domain/usecases/terminate_session.dart';

class MockTerminateSessionRepository extends Mock
    implements TerminateSessionRepository {}

void main() {
  TerminateSession usecase;
  MockTerminateSessionRepository mockTerminateSessionRepository;

  setUp(() {
    mockTerminateSessionRepository = MockTerminateSessionRepository();
    usecase = TerminateSession(
      repository: mockTerminateSessionRepository,
    );
  });

  final String tTautulliId = 'jkl';
  final String tSessionId = 'm8bbpxpywe6i91zib3hnfltz';

  test(
    'should return true when session is terminated successfully',
    () async {
      // arrange
      when(
        mockTerminateSessionRepository(
          tautulliId: anyNamed('tautulliId'),
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
        ),
      ).thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
      );
      // assert
      expect(result, equals(Right(true)));
    },
  );
}
