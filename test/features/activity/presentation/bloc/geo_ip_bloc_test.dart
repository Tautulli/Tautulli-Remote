import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/usecases/get_geo_ip.dart';
import 'package:tautulli_remote_tdd/features/activity/presentation/bloc/geo_ip_bloc.dart';

class MockGetGeoIp extends Mock implements GetGeoIp {}

void main() {
  GeoIpBloc bloc;
  MockGetGeoIp mockGetGeoIp;

  setUp(() {
    mockGetGeoIp = MockGetGeoIp();
    bloc = GeoIpBloc(
      getGeoIp: mockGetGeoIp,
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
          tautulliId: anyNamed('tautulliId'),
          ipAddress: anyNamed('ipAddress'),
        ),
      );
    },
  );
}
