import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/terminate_session/domain/usecases/terminate_session.dart';
import 'package:tautulli_remote/features/terminate_session/presentation/bloc/terminate_session_bloc.dart';
import 'package:tautulli_remote/core/error/failure.dart';

class MockTerminateSession extends Mock implements TerminateSession {}

class MockLogging extends Mock implements Logging {}

void main() {
  MockTerminateSession mockTerminateSession;
  MockLogging mockLogging;
  TerminateSessionBloc bloc;

  setUp(() {
    mockTerminateSession = MockTerminateSession();
    mockLogging = MockLogging();

    bloc = TerminateSessionBloc(
      terminateSession: mockTerminateSession,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final String tSessionId = 'm8bbpxpywe6i91zib3hnfltz';

  void setUpSuccess() {
    when(
      mockTerminateSession(
        tautulliId: anyNamed('tautulliId'),
        sessionId: anyNamed('sessionId'),
        message: anyNamed('message'),
      ),
    ).thenAnswer((_) async => Right(true));
  }

  test(
    'initialState should be TerminateSessionInitial',
    () async {
      // assert
      expect(bloc.state, TerminateSessionInitial());
    },
  );

  group('TerminateSessionStarted', () {
    test(
      'should call TerminateSession use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          TerminateSessionStarted(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
          ),
        );
        await untilCalled(
          mockTerminateSession(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
          ),
        );
        // assert
        verify(
          mockTerminateSession(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
          ),
        );
      },
    );

    test(
      'should emit [TerminateSessionInProgress, TerminateSessionSuccess] when session is terminate successfully',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          TerminateSessionInProgress(sessionId: tSessionId),
          TerminateSessionSuccess(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          TerminateSessionStarted(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
          ),
        );
      },
    );

    test(
      'should emit [TerminateSessionInProgress, TerminateSessionFailure] when session fails to terminate',
      () async {
        // arrange
        when(
          mockTerminateSession(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
          ),
        ).thenAnswer((_) async => Left(TerminateFailure()));
        // assert later
        final expected = [
          TerminateSessionInProgress(sessionId: tSessionId),
          TerminateSessionFailure(failure: TerminateFailure()),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          TerminateSessionStarted(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
          ),
        );
      },
    );
  });
}
