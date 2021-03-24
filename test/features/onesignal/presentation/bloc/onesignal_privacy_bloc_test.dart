import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/core/database/domain/entities/server.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';

class MockOneSignalDataSourceImpl extends Mock
    implements OneSignalDataSourceImpl {}

class MockSettings extends Mock implements Settings {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  OneSignalPrivacyBloc bloc;
  MockSettings mockSettings;
  MockRegisterDevice mockRegisterDevice;
  MockOneSignalDataSourceImpl mockOneSignalDataSourceImpl;
  MockLogging mockLogging;

  setUp(() {
    mockSettings = MockSettings();
    mockRegisterDevice = MockRegisterDevice();
    mockOneSignalDataSourceImpl = MockOneSignalDataSourceImpl();
    mockLogging = MockLogging();

    bloc = OneSignalPrivacyBloc(
      oneSignal: mockOneSignalDataSourceImpl,
      settings: mockSettings,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  final Server tServerModel = ServerModel(
    primaryConnectionAddress: 'http://tautulli.com',
    primaryConnectionProtocol: 'http',
    primaryConnectionDomain: 'tautulli.com',
    primaryConnectionPath: null,
    deviceToken: 'abc',
    tautulliId: 'jkl',
    plexName: 'Plex',
    plexIdentifier: 'xyz',
    primaryActive: true,
    plexPass: true,
  );

  final List<Server> tServerList = [tServerModel];

  test(
    'initialState should be OneSignalPrivacyInitial',
    () async {
      // assert
      expect(bloc.state, OneSignalPrivacyInitial());
    },
  );

  test(
    'should emit [OneSignalPrivacyConsentSuccess] when consent has been granted',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.isSubscribed)
          .thenAnswer((_) async => true);
      // assert later
      final expected = [
        OneSignalPrivacyConsentSuccess(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(OneSignalPrivacyCheckConsent());
    },
  );

  test(
    'should emit [OneSignalPrivacyConsentFailure] when consent has not been granted',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.isSubscribed)
          .thenAnswer((_) async => null);
      // assert later
      final expected = [
        OneSignalPrivacyConsentFailure(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(OneSignalPrivacyCheckConsent());
    },
  );

  group('GrantConsent', () {
    test(
      'should grant concent when OneSignalPrivacyGrantConsent event is triggered',
      () async {
        // act
        bloc.add(OneSignalPrivacyGrantConsent());
        await untilCalled(mockOneSignalDataSourceImpl.grantConsent(any));
        // assert
        verify(mockOneSignalDataSourceImpl.grantConsent(true));
      },
    );

    test(
      'should emit [OneSignalPrivacyConsentSuccess] when OneSignalPrivacyGrantConsent event is triggered',
      () async {
        // assert later
        final expected = [
          OneSignalPrivacyConsentSuccess(),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(OneSignalPrivacyGrantConsent());
      },
    );

    // test(
    //   'should call RegisterDevice without clearOnesignalId set when OneSignalPrivacyGrantConsent event is triggered',
    //   () async {
    //     // arrange
    //     when(mockGetSettings.load()).thenAnswer((_) async => tSettingsModel);
    //     // act
    //     bloc.add(OneSignalPrivacyGrantConsent());
    //     await untilCalled(
    //       mockRegisterDevice(
    //         connectionProtocol: anyNamed('connectionProtocol'),
    //         connectionDomain: anyNamed('connectionDomain'),
    //         connectionUser: anyNamed('connectionUser'),
    //         connectionPassword: anyNamed('connectionPassword'),
    //         deviceToken: anyNamed('deviceToken'),
    //         clearOnesignalId: anyNamed('clearOnesignalId'),
    //       ),
    //     );
    //     // assert
    //     verify(
    //       mockRegisterDevice(
    //         connectionProtocol: tSettingsModel.connectionProtocol,
    //         connectionDomain: tSettingsModel.connectionDomain,
    //         connectionUser: tSettingsModel.connectionUser,
    //         connectionPassword: tSettingsModel.connectionPassword,
    //         deviceToken: tSettingsModel.deviceToken,
    //       ),
    //     );
    //   },
    // );
  });

  group('RevokeConsent', () {
    setUp(() {
      when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
    });

    test(
      'should revoke concent when OneSignalPrivacyRevokeConsent event is triggered',
      () async {
        // act
        bloc.add(OneSignalPrivacyRevokeConsent());
        await untilCalled(mockOneSignalDataSourceImpl.grantConsent(any));
        // assert
        verify(mockOneSignalDataSourceImpl.grantConsent(false));
      },
    );

    // test(
    //   'should call RegisterDevice with clearOnesignalId = true when OneSignalPrivacyRevokeConsent event is triggered',
    //   () async {
    //     // act
    //     bloc.add(OneSignalPrivacyRevokeConsent());
    //     await untilCalled(
    //       mockRegisterDevice(
    //         connectionProtocol: anyNamed('connectionProtocol'),
    //         connectionDomain: anyNamed('connectionDomain'),
    //         connectionUser: anyNamed('connectionUser'),
    //         connectionPassword: anyNamed('connectionPassword'),
    //         deviceToken: anyNamed('deviceToken'),
    //         clearOnesignalId: anyNamed('clearOnesignalId'),
    //       ),
    //     );
    //     // assert
    //     verify(
    //       mockRegisterDevice(
    //         connectionProtocol: anyNamed('connectionProtocol'),
    //         connectionDomain: anyNamed('connectionDomain'),
    //         connectionUser: anyNamed('connectionUser'),
    //         connectionPassword: anyNamed('connectionPassword'),
    //         deviceToken: anyNamed('deviceToken'),
    //         clearOnesignalId: true,
    //       ),
    //     );
    //   },
    // );

    test(
      'should emit [OneSignalPrivacyConsentFailure] when OneSignalPrivacyRevokeConsent event is triggered',
      () async {
        // assert later
        final expected = [
          OneSignalPrivacyConsentFailure(),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(OneSignalPrivacyRevokeConsent());
      },
    );
  });
}
