import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/api/tautulli_api.dart';
import 'package:tautulli_remote_tdd/core/device_info/device_info.dart';
import 'package:tautulli_remote_tdd/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote_tdd/features/settings/data/datasources/register_device_data_source.dart';
import 'package:matcher/matcher.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

class MockDeviceInfo extends Mock implements DeviceInfo {}

class MockOneSignalDataSource extends Mock implements OneSignalDataSource {}

void main() {
  RegisterDeviceDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;
  MockDeviceInfo mockDeviceInfo;
  MockOneSignalDataSource mockOneSignalDataSource;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    mockDeviceInfo = MockDeviceInfo();
    mockOneSignalDataSource = MockOneSignalDataSource();
    dataSource = RegisterDeviceDataSourceImpl(
      tautulliApi: mockTautulliApi,
      deviceInfo: mockDeviceInfo,
      oneSignal: mockOneSignalDataSource,
    );
  });

  final String tConnectionProtocol = 'http';
  final String tConnectionDomain = 'tautulli.com';
  final String tConnectionPath = '/tautulli';
  final String tDeviceToken = 'abc';
  final String tDeviceName = 'test';
  final String tDeviceId = 'lmn';
  final String tOnesignalId = 'xyz';

  void setUpMockRegisterDeviceSuccess() {
    Map<String, dynamic> registerJson = {
      "response": {
        "result": "success",
        "data": {
          "pms_name": "Starlight",
          "server_id": "<tautulli_server_id>",
          'tautulli_version': 'v0.0.0',
        }
      }
    };
    when(
      mockTautulliApi.registerDevice(
        connectionProtocol: anyNamed('connectionProtocol'),
        connectionDomain: anyNamed('connectionDomain'),
        connectionPath: anyNamed('connectionPath'),
        deviceToken: anyNamed('deviceToken'),
        deviceId: anyNamed('deviceId'),
        deviceName: anyNamed('deviceName'),
        onesignalId: anyNamed('onesignalId'),
      ),
    ).thenAnswer((_) async => registerJson);
  }

  void setUpDeviceInfoSuccess() {
    when(mockDeviceInfo.model).thenAnswer((_) async => tDeviceName);
    when(mockDeviceInfo.uniqueId).thenAnswer((_) async => tDeviceId);
  }

  void setUpOneSignalSuccess() {
    when(mockOneSignalDataSource.userId).thenAnswer((_) async => tOnesignalId);
  }

  group('register device data source', () {
    test(
      'should query DataInfo for deviceId and uniqueId',
      () async {
        // arrange
        setUpMockRegisterDeviceSuccess();
        setUpDeviceInfoSuccess();
        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
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
        setUpMockRegisterDeviceSuccess();
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(mockOneSignalDataSource.userId);
      },
    );

    test(
      'should call [registerDevice] from TautulliApi',
      () async {
        // arrange
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
        setUpMockRegisterDeviceSuccess();

        // act
        await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        verify(
          mockTautulliApi.registerDevice(
            connectionProtocol: tConnectionProtocol,
            connectionDomain: tConnectionDomain,
            connectionPath: tConnectionPath,
            deviceToken: tDeviceToken,
            deviceName: tDeviceName,
            deviceId: tDeviceId,
            onesignalId: tOnesignalId,
          ),
        );
      },
    );

    test(
      'should return Map with response data',
      () async {
        // arrange
        setUpDeviceInfoSuccess();
        setUpOneSignalSuccess();
        setUpMockRegisterDeviceSuccess();
        // act
        final result = await dataSource(
          connectionProtocol: tConnectionProtocol,
          connectionDomain: tConnectionDomain,
          connectionPath: tConnectionPath,
          deviceToken: tDeviceToken,
        );
        // assert
        expect(result, TypeMatcher<Map>());
      },
    );
  });
}
