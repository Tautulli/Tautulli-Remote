import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tautulli_remote_tdd/core/helpers/tautulli_api_url_helper.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/features/activity/data/datasources/activity_data_source.dart';
import 'package:tautulli_remote_tdd/features/activity/domain/entities/activity.dart';
import 'package:tautulli_remote_tdd/features/activity/data/models/activity_model.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/get_settings.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockGetSettings extends Mock implements GetSettings {}

class MockTautulliApiUrls extends Mock implements TautulliApiUrls {}

void main() {
  ActivityDataSourceImpl dataSource;
  MockTautulliApiUrls mockTautulliApiUrls;
  MockHttpClient mockHttpClient;
  MockGetSettings mockGetSettings;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockGetSettings = MockGetSettings();
    mockTautulliApiUrls = MockTautulliApiUrls();
    dataSource = ActivityDataSourceImpl(
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
        .thenAnswer((_) async => http.Response(fixture('activity.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getActivity', () {
    List<ActivityItem> tActivityList = [];

    final activityJson = json.decode(fixture('activity.json'));

    activityJson['response']['data']['sessions'].forEach(
      (session) {
        tActivityList.add(
          ActivityItemModel.fromJson(session),
        );
      },
    );

    group('without Basic Auth', () {
      test(
        'should perform a GET request on a URL provided by tautulliAPI.getActivityUrl with application/json header',
        () async {
          // arrange
          setUpSettingsSuccess();
          setUpMockHttpClientSuccess200();
          //act
          await dataSource.getActivity();
          //assert
          verify(
            mockTautulliApiUrls.getActivityUrl(
              protocol: settingsModel.connectionProtocol,
              domain: settingsModel.connectionDomain,
              deviceToken: settingsModel.deviceToken,
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
          final call = dataSource.getActivity;
          // assert
          expect(() => call(), throwsA(TypeMatcher<SettingsException>()));
        },
      );

      test(
        'should return list of ActivityItem when the response code is 200',
        () async {
          // arrange
          setUpSettingsSuccess();
          setUpMockHttpClientSuccess200();
          //act
          final result = await dataSource.getActivity();
          //assert
          expect(result, equals(tActivityList));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          setUpSettingsSuccess();
          setUpMockHttpClientFailure404();
          //act
          final call = dataSource.getActivity;
          //assert
          expect(() => call(), throwsA(TypeMatcher<ServerException>()));
        },
      );
    });

    group('with Basic Auth', () {
      test(
        'should perform a GET request on a URL provided by tautulliAPI.getActivityUrl with application/json and authorization header',
        () async {
          // arrange
          setUpSettingsSuccessWithBasicAuth();
          setUpMockHttpClientSuccess200();
          //act
          await dataSource.getActivity();
          //assert
          verify(
            mockTautulliApiUrls.getActivityUrl(
              protocol: settingsModelWithBasicAuth.connectionProtocol,
              domain: settingsModelWithBasicAuth.connectionDomain,
              deviceToken: settingsModelWithBasicAuth.deviceToken,
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
          final call = dataSource.getActivity;
          // assert
          expect(() => call(), throwsA(TypeMatcher<SettingsException>()));
        },
      );

      test(
        'should return list of ActivityItem when the response code is 200',
        () async {
          // arrange
          setUpSettingsSuccessWithBasicAuth();
          setUpMockHttpClientSuccess200();
          //act
          final result = await dataSource.getActivity();
          //assert
          expect(result, equals(tActivityList));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          // arrange
          setUpSettingsSuccessWithBasicAuth();
          setUpMockHttpClientFailure404();
          //act
          final call = dataSource.getActivity;
          //assert
          expect(() => call(), throwsA(TypeMatcher<ServerException>()));
        },
      );
    });
  });
}
