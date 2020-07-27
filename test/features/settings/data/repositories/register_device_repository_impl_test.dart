import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/settings/data/datasources/register_device_data_source.dart';
import 'package:tautulli_remote_tdd/features/settings/data/repositories/register_device_repository_impl.dart';

class MockRegisterDeviceDataSource extends Mock
    implements RegisterDeviceDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  RegisterDeviceRepositoryImpl repository;
  MockRegisterDeviceDataSource mockDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockDataSource = MockRegisterDeviceDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RegisterDeviceRepositoryImpl(
      dataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final String tConnectionProtocol = 'http';
  final String tConnectionDomain = 'tautulli.com';
  final String tConnectionUser = 'user';
  final String tConnectionPassword = 'pass';
  final String tDeviceToken = 'abc';

  test(
    'should check if the device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository(
        connectionProtocol: tConnectionProtocol,
        connectionDomain: tConnectionDomain,
        connectionUser: tConnectionUser,
        connectionPassword: tConnectionPassword,
        deviceToken: tDeviceToken,
      );
      //assert
      verify(mockNetworkInfo.isConnected);
    },
  );

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    group('without Basic Auth', () {
      test(
        'should call data source ',
        () async {
          // act
          await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          verify(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          );
        },
      );

      test(
        'should return a Map with response data when the call to api is successful',
        () async {
          // arrange
          Map responseMap = {
            "data": {"pms_name": "Starlight", "server_id": "abc"}
          };
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          ).thenAnswer(
            (_) async => responseMap,
          );
          //act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          //assert
          expect(result, equals(Right(responseMap)));
        },
      );

      test(
        'should return ServerFailure when the call to the api is unsuccessful',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(ServerException());
          //act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          //assert
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should return SocketFailure when a SocketException is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(SocketException.closed());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(SocketFailure())));
        },
      );

      test(
        'should return a TlsFailure when a TlsException is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(TlsException());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(TlsFailure())));
        },
      );

      test(
        'should return a UrlFormatFailure when a FormatException is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(FormatException());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(UrlFormatFailure())));
        },
      );

      test(
        'should return a UrlFormatFailure when an ArgumentError is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(ArgumentError());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(UrlFormatFailure())));
        },
      );

      test(
        'should return a TimeoutException when the get request times out',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(TimeoutException(''));
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(TimeoutFailure())));
        },
      );
    });

    group('with Basic Auth', () {
      test(
        'should call data source ',
        () async {
          // act
          await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          verify(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          );
        },
      );

      test(
        'should return true when the call to api is successful',
        () async {
          // arrange
          Map responseMap = {
            "data": {"pms_name": "Starlight", "server_id": "abc"}
          };
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          ).thenAnswer((_) async => responseMap);
          //act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          //assert
          expect(result, equals(Right(responseMap)));
        },
      );

      test(
        'should return ServerFailure when the call to the api is unsuccessful',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(ServerException());
          //act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          //assert
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should return SocketFailure when a SocketException is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(SocketException.closed());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(SocketFailure())));
        },
      );

      test(
        'should return a TlsFailure when a TlsException is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(TlsException());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(TlsFailure())));
        },
      );

      test(
        'should return a UrlFormatFailure when a FormatException is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(FormatException());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(UrlFormatFailure())));
        },
      );

      test(
        'should return a UrlFormatFailure when an ArgumentError is thrown',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(ArgumentError());
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(UrlFormatFailure())));
        },
      );
      test(
        'should return a TimeoutException when the get request times out',
        () async {
          // arrange
          when(
            mockDataSource(
              connectionProtocol: tConnectionProtocol,
              connectionDomain: tConnectionDomain,
              connectionUser: tConnectionUser,
              connectionPassword: tConnectionPassword,
              deviceToken: tDeviceToken,
            ),
          ).thenThrow(TimeoutException(''));
          // act
          final result = await repository(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, equals(Left(TimeoutFailure())));
        },
      );
    });
  });

  group('device is offline', () {
    test(
      'should return a ConnectionFailure when there is no internet',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        //act
        final result = await repository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionUser: tConnectionUser,
          connectionPassword: tConnectionPassword,
          deviceToken: tDeviceToken,
        );
        //assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
