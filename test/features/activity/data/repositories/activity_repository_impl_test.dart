import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:matcher/matcher.dart';

class MockActivityDataSource extends Mock implements ActivityDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFailureMapperHelper extends Mock implements FailureMapperHelper {}

void main() {
  ActivityRepositoryImpl repository;
  MockActivityDataSource dataSource;
  MockNetworkInfo mockNetworkInfo;
  MockFailureMapperHelper mockFailureMapperHelper;

  setUp(() {
    dataSource = MockActivityDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockFailureMapperHelper = MockFailureMapperHelper();
    repository = ActivityRepositoryImpl(
      dataSource: dataSource,
      networkInfo: mockNetworkInfo,
      failureMapperHelper: mockFailureMapperHelper,
    );
  });

  group('getActivity', () {
    final Map<String, Map<String, Object>> tActivityMap = {
      'Plex': {
        'result': 'success',
        'activity': 'failure',
      }
    };

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repository.getActivity();
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call data source getActivity()',
        () async {
          // act
          await repository.getActivity();
          // assert
          verify(dataSource.getActivity());
        },
      );

      test(
        'should return activity data map when the call to api is successful',
        () async {
          // arrange
          when(dataSource.getActivity()).thenAnswer((_) async => tActivityMap);
          //act
          final result = await repository.getActivity();
          //assert
          expect(result, equals(Right(tActivityMap)));
        },
      );

      test(
        'should return activity',
        () async {
          // arrange
          when(dataSource.getActivity()).thenAnswer((_) async => tActivityMap);
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Right(tActivityMap)));
        },
      );

      test(
        'should return proper Failure using FailureMapperHelper if a known exception is thrown',
        () async {
          // arrange
          final exception = SettingsException();
          when(dataSource.getActivity()).thenThrow(exception);
          when(mockFailureMapperHelper.mapExceptionToFailure(exception)).thenReturn(SettingsFailure());
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Left(SettingsFailure())));
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
          final result = await repository.getActivity();
          //assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
