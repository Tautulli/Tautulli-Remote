import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote/features/activity/data/models/geo_ip_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetGeoipLookup extends Mock implements tautulliApi.GetGeoipLookup {}

class MockLogging extends Mock implements Logging {}

void main() {
  GeoIpDataSourceImpl dataSource;
  MockGetGeoipLookup mockApiGetGeoipLookup;
  MockLogging mockLogging;

  setUp(() {
    mockApiGetGeoipLookup = MockGetGeoipLookup();
    mockLogging = MockLogging();
    dataSource = GeoIpDataSourceImpl(
      apiGetGeoipLookup: mockApiGetGeoipLookup,
      logging: mockLogging,
    );
  });

  final serverModel = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionPath: null,
    deviceToken: 'abc',
    plexName: 'Plex',
    plexIdentifier: 'xyz',
    tautulliId: 'jkl',
    primaryActive: true,
    plexPass: true,
  );

  final tIpAddress = '10.0.0.1';

  final tGeoIpItem = GeoIpItemModel(
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

  group('getGeoIp', () {
    test(
      'should call [getGeoipLookup] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetGeoipLookup(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
          ),
        ).thenAnswer((_) async => json.decode(fixture('geo_ip.json')));
        // act
        await dataSource.getGeoIp(
          tautulliId: serverModel.tautulliId,
          ipAddress: tIpAddress,
        );
        // assert
        verify(
          mockApiGetGeoipLookup(
            tautulliId: serverModel.tautulliId,
            ipAddress: tIpAddress,
          ),
        );
      },
    );

    test(
      'should return GeoIpItem',
      () async {
        // arrange
        when(
          mockApiGetGeoipLookup(
            tautulliId: anyNamed('tautulliId'),
            ipAddress: anyNamed('ipAddress'),
          ),
        ).thenAnswer((_) async => json.decode(fixture('geo_ip.json')));
        //act
        final result = await dataSource.getGeoIp(
          tautulliId: serverModel.tautulliId,
          ipAddress: tIpAddress,
        );
        //assert
        expect(result, equals(tGeoIpItem));
      },
    );
  });
}
