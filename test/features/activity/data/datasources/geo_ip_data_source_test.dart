import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/database/data/models/server_model.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/helpers/tautulli_api_url_helper.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/geo_ip_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/settings.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockGetSettings extends Mock implements Settings {}

class MockTautulliApiUrls extends Mock implements TautulliApiUrls {}

class MockLogging extends Mock implements Logging {}

void main() {
  GeoIpDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  MockGetSettings mockSettings;
  MockTautulliApiUrls mockTautulliApiUrls;
  MockLogging mockLogging;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSettings = MockGetSettings();
    mockTautulliApiUrls = MockTautulliApiUrls();
    mockLogging = MockLogging();
    dataSource = GeoIpDataSourceImpl(
      client: mockHttpClient,
      settings: mockSettings,
      tautulliApiUrls: mockTautulliApiUrls,
      logging: mockLogging,
    );
  });

  final serverModel = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionUser: null,
    primaryConnectionPassword: null,
    deviceToken: 'abc',
    plexName: 'Plex',
    tautulliId: 'jkl',
  );

  final serverModelWithBasicAuth = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionUser: 'user',
    primaryConnectionPassword: 'pass',
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
    group('without Basic Auth', () {
      test(
        'should perform a GET request on geoIP URL using priamry connection address with application/json header',
        () async {
          // arrange
          when(mockSettings.getServerByTautulliId(serverModel.tautulliId))
              .thenAnswer((_) async => serverModel);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('geo_ip.json'), 200));
          // act
          await dataSource.getGeoIp(
              tautulliId: serverModel.tautulliId, ipAddress: tIpAddress);
          // assert
          verify(
            mockTautulliApiUrls.getGeoIpLookupUrl(
              protocol: serverModel.primaryConnectionProtocol,
              domain: serverModel.primaryConnectionDomain,
              deviceToken: serverModel.deviceToken,
              ipAddress: tIpAddress,
            ),
          );
          verify(
            mockHttpClient.get(
              any,
              headers: {
                'Content-Type': 'application/json',
              },
            ),
          );
        },
      );

      test(
        'should throw a TimeoutException if the GET request takes too long',
        () async {
          // arrange
          when(mockSettings.getServerByTautulliId(serverModel.tautulliId))
              .thenAnswer((_) async => serverModel);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) => Future.delayed(Duration(seconds: 10)));
          // act
          final call = dataSource.getGeoIp;
          // assert
          expect(
              () => call(
                    tautulliId: serverModel.tautulliId,
                    ipAddress: tIpAddress,
                  ),
              throwsA(TypeMatcher<TimeoutException>()));
        },
      );

      test(
        'should return GeoIpItem when the response code is 200',
        () async {
          // arrange
          when(mockSettings.getServerByTautulliId(serverModel.tautulliId))
              .thenAnswer((_) async => serverModel);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('geo_ip.json'), 200));
          //act
          final result = await dataSource.getGeoIp(
              tautulliId: serverModel.tautulliId, ipAddress: tIpAddress);
          //assert
          expect(result, equals(tGeoIpItem));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          when(mockSettings.getServerByTautulliId(serverModel.tautulliId))
              .thenAnswer((_) async => serverModel);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response('failure', 404));
          //act
          final call = dataSource.getGeoIp;
          //assert
          expect(
              () => call(
                    tautulliId: serverModel.tautulliId,
                    ipAddress: tIpAddress,
                  ),
              throwsA(TypeMatcher<ServerException>()));
        },
      );
    });

    group('with Basic Auth', () {
      test(
        'should perform a GET request on geoIP URL using priamry connection address with application/json header',
        () async {
          // arrange
          when(mockSettings
                  .getServerByTautulliId(serverModelWithBasicAuth.tautulliId))
              .thenAnswer((_) async => serverModelWithBasicAuth);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('geo_ip.json'), 200));
          // act
          await dataSource.getGeoIp(
              tautulliId: serverModelWithBasicAuth.tautulliId,
              ipAddress: tIpAddress);
          // assert
          verify(
            mockTautulliApiUrls.getGeoIpLookupUrl(
              protocol: serverModelWithBasicAuth.primaryConnectionProtocol,
              domain: serverModelWithBasicAuth.primaryConnectionDomain,
              deviceToken: serverModelWithBasicAuth.deviceToken,
              ipAddress: tIpAddress,
            ),
          );
          verify(
            mockHttpClient.get(
              any,
              headers: {
                'Content-Type': 'application/json',
                'authorization': 'Basic ' +
                    base64Encode(
                      utf8.encode(
                          '${serverModelWithBasicAuth.primaryConnectionUser}:${serverModelWithBasicAuth.primaryConnectionPassword}'),
                    ),
              },
            ),
          );
        },
      );

      test(
        'should throw a TimeoutException if the GET request takes too long',
        () async {
          // arrange
          when(mockSettings
                  .getServerByTautulliId(serverModelWithBasicAuth.tautulliId))
              .thenAnswer((_) async => serverModelWithBasicAuth);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) => Future.delayed(Duration(seconds: 10)));
          // act
          final call = dataSource.getGeoIp;
          // assert
          expect(
              () => call(
                    tautulliId: serverModelWithBasicAuth.tautulliId,
                    ipAddress: tIpAddress,
                  ),
              throwsA(TypeMatcher<TimeoutException>()));
        },
      );

      test(
        'should return GeoIpItem when the response code is 200',
        () async {
          // arrange
          when(mockSettings
                  .getServerByTautulliId(serverModelWithBasicAuth.tautulliId))
              .thenAnswer((_) async => serverModelWithBasicAuth);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('geo_ip.json'), 200));
          //act
          final result = await dataSource.getGeoIp(
              tautulliId: serverModelWithBasicAuth.tautulliId,
              ipAddress: tIpAddress);
          //assert
          expect(result, equals(tGeoIpItem));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          when(mockSettings
                  .getServerByTautulliId(serverModelWithBasicAuth.tautulliId))
              .thenAnswer((_) async => serverModelWithBasicAuth);
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response('failure', 404));
          //act
          final call = dataSource.getGeoIp;
          //assert
          expect(
              () => call(
                    tautulliId: serverModelWithBasicAuth.tautulliId,
                    ipAddress: tIpAddress,
                  ),
              throwsA(TypeMatcher<ServerException>()));
        },
      );
    });
  });
}
