import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote/features/activity/domain/usecases/get_geo_ip.dart';
import 'package:tautulli_remote/features/activity/presentation/bloc/geo_ip_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';

class MockGetGeoIp extends Mock implements GetGeoIp {}

class MockLogging extends Mock implements Logging {}

void main() {
  GeoIpBloc bloc;
  MockGetGeoIp mockGetGeoIp;
  MockLogging mockLogging;

  setUp(() {
    mockGetGeoIp = MockGetGeoIp();
    mockLogging = MockLogging();
    bloc = GeoIpBloc(
      getGeoIp: mockGetGeoIp,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'abc';
  final tIpAddress = '10.0.0.1';

  final tGeoIpItemModel = GeoIpItemModel(
    accuracy: null,
    city: "Toronto",
    code: "CA",
    continent: null,
    country: "Canada",
    latitude: 43.6403,
    longitude: -79.3711,
    postalCode: "M5E",
    region: "Ontario",
    timezone: "America/Toronto",
  );

  final tGeoIpMap = {
    tIpAddress: tGeoIpItemModel,
  };

  void setUpSuccess() {
    when(
      mockGetGeoIp(
        tautulliId: anyNamed('tautulliId'),
        ipAddress: anyNamed('ipAddress'),
      ),
    ).thenAnswer((_) async => Right(tGeoIpItemModel));
  }

  test(
    'should get data from the GetGeoIp use case',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // act
      bloc.add(
        GeoIpLoad(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        ),
      );
      await untilCalled(
        mockGetGeoIp(
          tautulliId: anyNamed('tautulliId'),
          ipAddress: anyNamed('ipAddress'),
        ),
      );
      // assert
      verify(
        mockGetGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        ),
      );
    },
  );

  test(
    'should emit [GeoIpSuccess] when users list is fetched successfully',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // assert later
      final expected = [
        GeoIpInProgress(),
        GeoIpSuccess(
          geoIpMap: tGeoIpMap,
        ),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(
        GeoIpLoad(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        ),
      );
    },
  );

  test(
    'should emit [GeoIpFailure] when fetching users list fails',
    () async {
      // arrange
      final failure = ServerFailure();
      clearCache();
      when(
        mockGetGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        ),
      ).thenAnswer((_) async => Left(failure));
      // assert later
      final expected = [
        GeoIpInProgress(),
        GeoIpFailure(
          geoIpMap: {},
        ),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(
        GeoIpLoad(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
        ),
      );
    },
  );
}
