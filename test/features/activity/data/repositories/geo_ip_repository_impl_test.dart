import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote_tdd/features/activity/data/repositories/geo_ip_repository_impl.dart';

class MockGeoIpDataSouce extends Mock implements GeoIpDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  GeoIpRepositoryImpl repository;
  MockGeoIpDataSouce dataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    dataSource = MockGeoIpDataSouce();
    mockNetworkInfo = MockNetworkInfo();
    repository = GeoIpRepositoryImpl(
      dataSource: dataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTautulliId = 'jkl';

  final tIpAddress = '10.0.0.1';

  final tGeoIpItemModel = GeoIpItemModel(
    accuracy: null,
    city: "Chicago",
    code: "US",
    continent: null,
    country: "United States",
    latitude: 41.6984,
    longitude: -87.7031,
    postalCode: "60655",
    region: "Illinois",
    timezone: "America/Chicago",
  );

  test(
    'should check if the device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getGeoIp(
        tautulliId: tTautulliId,
        ipAddress: tIpAddress,
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
      'should call data source getGeoIp()',
      () async {
        // act
        await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        // assert
        verify(
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        );
      },
    );

    test(
      'should return GeoIpItem when the call to api is successful',
      () async {
        // arrange
        when(
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        ).thenAnswer((_) async => tGeoIpItemModel);
        //act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        //assert
        expect(result, equals(Right(tGeoIpItemModel)));
      },
    );

    test(
      'should return SettingsFailure if a SettingsException is thrown',
      () async {
        // arrange
        when(
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        ).thenThrow(SettingsException());
        // act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        // assert
        expect(result, equals(Left(SettingsFailure())));
      },
    );

    test(
      'should return ServerFailure when the call to the api is unsuccessful',
      () async {
        // arrange
        when(
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        ).thenThrow(ServerException());
        //act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
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
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        ).thenThrow(SocketException.closed());
        // act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
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
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        ).thenThrow(TlsException());
        // act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        // assert
        expect(result, equals(Left(TlsFailure())));
      },
    );

    test(
      'should return a UrlFormatFailure when a FormatException is thrown',
      () async {
        // arrange
        when(dataSource.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        )).thenThrow(FormatException());
        // act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
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
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        ).thenThrow(ArgumentError());
        // act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        // assert
        expect(result, equals(Left(UrlFormatFailure())));
      },
    );

    test(
      'should return a TimeoutFailure when a TimeoutException is thrown',
      () async {
        // arrange
        when(
          dataSource.getGeoIp(
            tautulliId: tTautulliId,
            ipAddress: tIpAddress,
          ),
        ).thenThrow(TimeoutException(''));
        // act
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
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
        final result = await repository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        );
        //assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
