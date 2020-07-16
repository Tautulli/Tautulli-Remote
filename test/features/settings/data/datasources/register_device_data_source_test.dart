import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tautulli_remote_tdd/core/device_info/device_info.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/core/helpers/tautulli_api_url_helper.dart';
import 'package:tautulli_remote_tdd/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote_tdd/features/settings/data/datasources/register_device_data_source.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/set_settings.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSetSettings extends Mock implements SetSettings {}

class MockTautulliApiUrls extends Mock implements TautulliApiUrls {}

class MockDeviceInfo extends Mock implements DeviceInfo {}

class MockOneSignalDataSource extends Mock implements OneSignalDataSource {}

void main() {
  RegisterDeviceDataSourceImpl dataSource;
  MockTautulliApiUrls mockTautulliApiUrls;
  MockHttpClient mockHttpClient;
  MockSetSettings mockSetSettings;
  MockDeviceInfo mockDeviceInfo;
  MockOneSignalDataSource mockOneSignalDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSetSettings = MockSetSettings();
    mockTautulliApiUrls = MockTautulliApiUrls();
    mockDeviceInfo = MockDeviceInfo();
    mockOneSignalDataSource = MockOneSignalDataSource();
    dataSource = RegisterDeviceDataSourceImpl(
      client: mockHttpClient,
      setSettings: mockSetSettings,
      tautulliApiUrls: mockTautulliApiUrls,
      deviceInfo: mockDeviceInfo,
      oneSignal: mockOneSignalDataSource,
    );
  });

  final String tConnectionProtocol = 'http';
  final String tConnectionDomain = 'tautulli.com';
  final String tConnectionUser = 'user';
  final String tConnectionPassword = 'pass';
  final String tDeviceToken = 'abc';
  final String tDeviceName = 'test';
  final String tDeviceId = 'lmn';
  final String tOnesignalId = 'xyz';

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('activity.json'), 200));
  }

  void setUpDeviceInfoSuccess() {
    when(mockDeviceInfo.model).thenAnswer((_) async => tDeviceName);
    when(mockDeviceInfo.uniqueId).thenAnswer((_) async => tDeviceId);
  }

  void setUpOneSignalSuccess() {
    when(mockOneSignalDataSource.userId).thenAnswer((_) async => tOnesignalId);
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('register device data source', () {
    test(
      'should query DataInfo for deviceId and uniqueId',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        setUpDeviceInfoSuccess();
        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionUser: null,
          connectionPassword: null,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(mockDeviceInfo.model);
        verify(mockDeviceInfo.uniqueId);
      },
    );

    test(
      'should query OneSignalDataSource for userId',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionUser: null,
          connectionPassword: null,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(mockOneSignalDataSource.userId);
      },
    );

    group('without Basic Auth', () {
      setUp(() {
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
      });
      
      test(
        'should perform a GET request on a URL provided by tautulliAPI.registerDevice with application/json header',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();

          // act
          await dataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          verify(
            mockTautulliApiUrls.registerDevice(
              protocol: tConnectionProtocol,
              domain: tConnectionDomain,
              deviceToken: tDeviceToken,
              deviceName: tDeviceName,
              deviceId: tDeviceId,
              onesignalId: tOnesignalId,
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
        'should throw a ServerException if the status code is not 200',
        () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource;
          // assert
          expect(
              () => call(
                    connectionProtocol: tConnectionProtocol,
                    connectionDomain: tConnectionDomain,
                    connectionUser: null,
                    connectionPassword: null,
                    deviceToken: tDeviceToken,
                  ),
              throwsA(TypeMatcher<ServerException>()));
        },
      );

      test(
        'should return true if the status code is 200',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: null,
            connectionPassword: null,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, true);
        },
      );
    });

    group('with Basic Auth', () {
      setUp(() {
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
      });

      test(
        'should perform a GET request on a URL provided by tautulliAPI.registerDevice with application/json and authorization header',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          await dataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          verify(
            mockTautulliApiUrls.registerDevice(
              protocol: tConnectionProtocol,
              domain: tConnectionDomain,
              deviceToken: tDeviceToken,
              deviceName: tDeviceName,
              deviceId: tDeviceId,
              onesignalId: tOnesignalId,
            ),
          );
          verify(
            mockHttpClient.get(
              any,
              headers: {
                'Content-Type': 'application/json',
                'authorization': 'Basic ' +
                    base64Encode(
                      utf8.encode('$tConnectionUser:$tConnectionPassword'),
                    ),
              },
            ),
          );
        },
      );

      test(
        'should throw a ServerException if the status code is not 200',
        () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource;
          // assert
          expect(
              () => call(
                    connectionProtocol: tConnectionProtocol,
                    connectionDomain: tConnectionDomain,
                    connectionUser: tConnectionUser,
                    connectionPassword: tConnectionPassword,
                    deviceToken: tDeviceToken,
                  ),
              throwsA(TypeMatcher<ServerException>()));
        },
      );

      test(
        'should return true if the status code is 200',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionUser: tConnectionUser,
            connectionPassword: tConnectionPassword,
            deviceToken: tDeviceToken,
          );
          // assert
          expect(result, true);
        },
      );
    });
  });
}
