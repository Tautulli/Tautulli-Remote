import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/api/tautulli_api.dart';
import 'package:tautulli_remote_tdd/core/database/data/models/server_model.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/geo_ip_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

class MockLogging extends Mock implements Logging {}

void main() {
  GeoIpDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;
  MockLogging mockLogging;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    mockLogging = MockLogging();
    dataSource = GeoIpDataSourceImpl(
      tautulliApi: mockTautulliApi,
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
    tautulliId: 'jkl',
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
          mockTautulliApi.getGeoipLookup(
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
          mockTautulliApi.getGeoipLookup(
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
          mockTautulliApi.getGeoipLookup(
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
