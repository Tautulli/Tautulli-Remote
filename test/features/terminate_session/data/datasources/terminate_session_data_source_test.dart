import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/api/tautulli_api.dart';
import 'package:tautulli_remote_tdd/features/terminate_session/data/datasources/terminate_session_data_source.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

void main() {
  TerminateSessionDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    dataSource = TerminateSessionDataSourceImpl(
      tautulliApi: mockTautulliApi,
    );
  });

  final String tTautulliId = 'jkl';
  final String tSessionId = 'm8bbpxpywe6i91zib3hnfltz';

  final Map<String, dynamic> successMap = {
    'response': {
      'result': 'success',
    }
  };

  final Map<String, dynamic> failureMap = {
    'response': {
      'result': 'error',
    }
  };

  test(
    'should call [terminateSession] from TautulliApi',
    () async {
      // arrange
      when(
        mockTautulliApi.terminateSession(
          tautulliId: anyNamed('tautulliId'),
          
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
        ),
      ).thenAnswer((_) async => successMap);
      // act
      await dataSource(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
      );
      // assert
      verify(
        mockTautulliApi.terminateSession(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
        ),
      );
    },
  );

  test(
    'should return true is termination is successful',
    () async {
      // arrange
      when(
        mockTautulliApi.terminateSession(
          tautulliId: anyNamed('tautulliId'),
          
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
        ),
      ).thenAnswer((_) async => successMap);
      // act
      final result = await dataSource(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
      );
      // assert
      expect(result, equals(true));
    },
  );

  test(
    'should return false is termination fails',
    () async {
      // arrange
      when(
        mockTautulliApi.terminateSession(
          tautulliId: anyNamed('tautulliId'),
          
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
        ),
      ).thenAnswer((_) async => failureMap);
      // act
      final result = await dataSource(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
      );
      // assert
      expect(result, equals(false));
    },
  );
}
