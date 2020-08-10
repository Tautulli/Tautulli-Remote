import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote_tdd/features/activity/data/repositories/geo_ip_repository_impl.dart';

class MockGeoIpDataSouce extends Mock implements GeoIpDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFailureMapperHelper extends Mock implements FailureMapperHelper {}

void main() {
  GeoIpRepositoryImpl repository;
  MockGeoIpDataSouce dataSource;
  MockNetworkInfo mockNetworkInfo;
  MockFailureMapperHelper mockFailureMapperHelper;

  setUp(() {
    dataSource = MockGeoIpDataSouce();
    mockNetworkInfo = MockNetworkInfo();
    repository = GeoIpRepositoryImpl(
      dataSource: dataSource,
      networkInfo: mockNetworkInfo,
      failureMapperHelper: mockFailureMapperHelper,
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

    // test(
    //   'should return proper Failure using FailureMapperHelper if a known exception is thrown',
    //   () async {
    //     // arrange
    //     final exception = SettingsException();
    //     when(
    //       dataSource.getGeoIp(
    //         tautulliId: tTautulliId,
    //         ipAddress: tIpAddress,
    //       ),
    //     ).thenThrow(SettingsException());
    //     when(mockFailureMapperHelper.mapExceptionToFailure(exception))
    //         .thenReturn(SettingsFailure());
    //     // act
    //     final result = await repository.getGeoIp(
    //       tautulliId: tTautulliId,
    //       ipAddress: tIpAddress,
    //     );
    //     // assert
    //     expect(result, equals(Left(SettingsFailure())));
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
