import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/settings/data/datasources/register_device_data_source.dart';
import 'package:tautulli_remote/features/settings/data/repositories/register_device_repository_impl.dart';

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
  final String tConnectionPath = '/tautulli';
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
        connectionPath: tConnectionPath,
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

    test(
      'should call data source ',
      () async {
        // act
        await repository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(
          mockDataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
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
            connectionPath: tConnectionPath,
            deviceToken: tDeviceToken,
          ),
        ).thenAnswer(
          (_) async => responseMap,
        );
        //act
        final result = await repository(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        //assert
        expect(result, equals(Right(responseMap)));
      },
    );

    // test(
    //   'should return proper Failure using FailureMapperHelper if a known exception is thrown',
    //   () async {
    //     // arrange
    //     final exception = ServerException();
    //     when(
    //       mockDataSource(
    //         connectionProtocol: tConnectionProtocol,
    //         connectionDomain: tConnectionDomain,
    //         connectionPath: tConnectionPath,
    //         deviceToken: tDeviceToken,
    //       ),
    //     ).thenThrow(exception);
    //     when(mockFailureMapperHelper.mapExceptionToFailure(exception))
    //         .thenReturn(ServerFailure());
    //     // act
    //     final result = await repository(
    //       connectionProtocol: tConnectionProtocol,
    //       connectionDomain: tConnectionDomain,
    //       connectionPath: tConnectionPath,
    //       deviceToken: tDeviceToken,
    //     );
    //     // assert
    //     expect(result, equals(Left(ServerFailure())));
    //   },
    // );
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
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        //assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
