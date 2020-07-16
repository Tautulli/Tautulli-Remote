import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/helpers/tautulli_api_url_helper.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/geo_ip_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/get_settings.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockGetSettings extends Mock implements GetSettings {}

class MockTautulliApiUrls extends Mock implements TautulliApiUrls {}

void main() {
  GeoIpDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  MockGetSettings mockGetSettings;
  MockTautulliApiUrls mockTautulliApiUrls;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockGetSettings = MockGetSettings();
    mockTautulliApiUrls = MockTautulliApiUrls();
    dataSource = GeoIpDataSourceImpl(
      client: mockHttpClient,
      getSettings: mockGetSettings,
      tautulliApiUrls: mockTautulliApiUrls,
    );
  });

  final settingsModel = SettingsModel(
    connectionAddress: 'http://tautulli.com',
    connectionProtocol: 'http',
    connectionDomain: 'tautulli.com',
    connectionUser: null,
    connectionPassword: null,
    deviceToken: 'abc',
  );

  final settingsModelWithBasicAuth = SettingsModel(
    connectionAddress: 'http://tautulli.com',
    connectionProtocol: 'http',
    connectionDomain: 'tautulli.com',
    connectionUser: 'user',
    connectionPassword: 'pass',
    deviceToken: 'abc',
  );

  final ipAddress = '10.0.0.1';

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

  void setUpSettingsSuccess() {
    when(mockGetSettings.load()).thenAnswer(
      (_) async => settingsModel,
    );
  }

  void setUpSettingsSuccessWithBasicAuth() {
    when(mockGetSettings.load()).thenAnswer(
      (_) async => settingsModelWithBasicAuth,
    );
  }

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('geo_ip.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getGeoIp', () {
    group('without Basic Auth', () {
      test(
        'should perform a GET request on a URL provided by tautulliAPI.getGeoIpLookupUrl with application/json header',
        () async {
          // arrange
          setUpSettingsSuccess();
          setUpMockHttpClientSuccess200();
          // act
          await dataSource.getGeoIp(ipAddress);
          // assert
          verify(
            mockTautulliApiUrls.getGeoIpLookupUrl(
              protocol: settingsModel.connectionProtocol,
              domain: settingsModel.connectionDomain,
              deviceToken: settingsModel.deviceToken,
              ipAddress: ipAddress,
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
        'should throw a SettingsException when the Connection Address or Device Token settings are null',
        () async {
          // arrange
          when(mockGetSettings.load()).thenAnswer(
            (_) async => SettingsModel(
              connectionAddress: null,
              connectionProtocol: null,
              connectionDomain: null,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: null,
            ),
          );
          // act
          final call = dataSource.getGeoIp;
          // assert
          expect(
              () => call(ipAddress), throwsA(TypeMatcher<SettingsException>()));
        },
      );

      test(
        'should return GeoIpItem when the response code is 200',
        () async {
          // arrange
          setUpSettingsSuccess();
          setUpMockHttpClientSuccess200();
          //act
          final result = await dataSource.getGeoIp(ipAddress);
          //assert
          expect(result, equals(tGeoIpItem));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          setUpSettingsSuccess();
          setUpMockHttpClientFailure404();
          //act
          final call = dataSource.getGeoIp;
          //assert
          expect(
              () => call(ipAddress), throwsA(TypeMatcher<ServerException>()));
        },
      );
    });

    group('with Basic Auth', () {
      test(
        'should perform a GET request on a URL provided by tautulliAPI.getGeoIpLookupUrl with application/json and authorization header',
        () async {
          // arrange
          setUpSettingsSuccessWithBasicAuth();
          setUpMockHttpClientSuccess200();
          // act
          await dataSource.getGeoIp(ipAddress);
          // assert
          verify(
            mockTautulliApiUrls.getGeoIpLookupUrl(
              protocol: settingsModel.connectionProtocol,
              domain: settingsModel.connectionDomain,
              deviceToken: settingsModel.deviceToken,
              ipAddress: ipAddress,
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
                          '${settingsModelWithBasicAuth.connectionUser}:${settingsModelWithBasicAuth.connectionPassword}'),
                    ),
              },
            ),
          );
        },
      );

      test(
        'should throw a SettingsException when the Connection Address or Device Token settings are null',
        () async {
          // arrange
          when(mockGetSettings.load()).thenAnswer(
            (_) async => SettingsModel(
              connectionAddress: null,
              connectionProtocol: null,
              connectionDomain: null,
              connectionUser: null,
              connectionPassword: null,
              deviceToken: null,
            ),
          );
          // act
          final call = dataSource.getGeoIp;
          // assert
          expect(
              () => call(ipAddress), throwsA(TypeMatcher<SettingsException>()));
        },
      );

      test(
        'should return GeoIpItem when the response code is 200',
        () async {
          // arrange
          setUpSettingsSuccessWithBasicAuth();
          setUpMockHttpClientSuccess200();
          //act
          final result = await dataSource.getGeoIp(ipAddress);
          //assert
          expect(result, equals(tGeoIpItem));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          setUpSettingsSuccessWithBasicAuth();
          setUpMockHttpClientFailure404();
          //act
          final call = dataSource.getGeoIp;
          //assert
          expect(
              () => call(ipAddress), throwsA(TypeMatcher<ServerException>()));
        },
      );
    });
  });
}
