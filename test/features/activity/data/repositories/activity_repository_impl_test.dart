import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/activity.dart';
import 'package:matcher/matcher.dart';

class MockActivityDataSource extends Mock implements ActivityDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  ActivityRepositoryImpl repository;
  MockActivityDataSource dataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    dataSource = MockActivityDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ActivityRepositoryImpl(
      dataSource: dataSource,
      networkInfo: mockNetworkInfo,
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
        'should return SettingsFailure if a SettingsException is thrown',
        () async {
          // arrange
          when(dataSource.getActivity()).thenThrow(SettingsException());
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Left(SettingsFailure())));
        },
      );

      test(
        'should return ServerFailure when the call to the api is unsuccessful',
        () async {
          // arrange
          when(dataSource.getActivity()).thenThrow(ServerException());
          //act
          final result = await repository.getActivity();
          //assert
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should return SocketFailure when a SocketException is thrown',
        () async {
          // arrange
          when(dataSource.getActivity()).thenThrow(SocketException.closed());
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Left(SocketFailure())));
        },
      );

      test(
        'should return a TlsFailure when a TlsException is thrown',
        () async {
          // arrange
          when(dataSource.getActivity()).thenThrow(TlsException());
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Left(TlsFailure())));
        },
      );

      test(
        'should return a UrlFormatFailure when a FormatException is thrown',
        () async {
          // arrange
          when(dataSource.getActivity()).thenThrow(FormatException());
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Left(UrlFormatFailure())));
        },
      );

      test(
        'should return a UrlFormatFailure when an ArgumentError is thrown',
        () async {
          // arrange
          when(dataSource.getActivity()).thenThrow(ArgumentError());
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Left(UrlFormatFailure())));
        },
      );

      test(
        'should return a TimeoutFailure when a TimeoutException is thrown',
        () async {
          // arrange
          when(dataSource.getActivity()).thenThrow(TimeoutException(''));
          // act
          final result = await repository.getActivity();
          // assert
          expect(result, equals(Left(TimeoutFailure())));
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
