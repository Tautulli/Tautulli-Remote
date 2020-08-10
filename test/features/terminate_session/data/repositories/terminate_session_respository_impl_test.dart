import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/terminate_session/data/datasources/terminate_session_data_source.dart';
import 'package:tautulli_remote_tdd/features/terminate_session/data/repositories/terminate_session_repository_impl.dart';

class MockTerminateSessionDataSource extends Mock
    implements TerminateSessionDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFailureMapperHelper extends Mock implements FailureMapperHelper {}

void main() {
  TerminateSessionRepositoryImpl repository;
  MockTerminateSessionDataSource mockDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockFailureMapperHelper mockFailureMapperHelper;

  setUp(() {
    mockDataSource = MockTerminateSessionDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TerminateSessionRepositoryImpl(
      dataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
      failureMapperHelper: mockFailureMapperHelper,
    );
  });

  final String tTautulliId = 'jkl';
  final String tSessionId = 'm8bbpxpywe6i91zib3hnfltz';

  test(
    'should check if the device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockDataSource(
          tautulliId: anyNamed('tautulliId'),
          sessionId: anyNamed('sessionId'),
          message: anyNamed('message'),
        ),
      ).thenAnswer((_) async => true);
      //act
      await repository(
        tautulliId: tTautulliId,
        sessionId: tSessionId,
      );
      //assert
      verify(mockNetworkInfo.isConnected);
    },
  );

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should call data source',
      () async {
        // arrange
        when(
          mockDataSource(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
          ),
        ).thenAnswer((_) async => true);
        // act
        await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
        );
        // assert
        verify(
          mockDataSource(
            tautulliId: tTautulliId,
            sessionId: tSessionId,
          ),
        );
      },
    );

    test(
      'should return true when api reports success',
      () async {
        // arrange
        when(
          mockDataSource(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
          ),
        ).thenAnswer((_) async => true);
        // act
        final result = await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
        );
        // assert
        expect(result, equals(Right(true)));
      },
    );

    test(
      'should return TerminateSessionFailure when api reports an error',
      () async {
        // arrange
        when(
          mockDataSource(
            tautulliId: anyNamed('tautulliId'),
            sessionId: anyNamed('sessionId'),
            message: anyNamed('message'),
          ),
        ).thenAnswer((_) async => false);
        // act
        final result = await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
        );
        // assert
        expect(result, equals(Left(TerminateFailure())));
      },
    );
  });

  group('device is offline', () {
    test(
      'should return a ConnectionFailure when there is no internet',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        //act
        final result = await repository(
          tautulliId: tTautulliId,
          sessionId: tSessionId,
        );
        //assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
