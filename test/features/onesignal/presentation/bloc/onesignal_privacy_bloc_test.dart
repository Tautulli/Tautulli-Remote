import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote_tdd/features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/entities/settings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/get_settings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/register_device.dart';

class MockOneSignalDataSourceImpl extends Mock
    implements OneSignalDataSourceImpl {}

class MockGetSettings extends Mock implements GetSettings {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

void main() {
  OneSignalPrivacyBloc bloc;
  MockGetSettings mockGetSettings;
  MockRegisterDevice mockRegisterDevice;
  MockOneSignalDataSourceImpl mockOneSignalDataSourceImpl;

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockRegisterDevice = MockRegisterDevice();
    mockOneSignalDataSourceImpl = MockOneSignalDataSourceImpl();
    bloc = OneSignalPrivacyBloc(
      oneSignal: mockOneSignalDataSourceImpl,
      getSettings: mockGetSettings,
      registerDevice: mockRegisterDevice,
    );
  });

  final Settings tSettingsModel = SettingsModel(
    connectionAddress: 'http://tautulli.com',
    connectionProtocol: 'http',
    connectionDomain: 'tautulli.com',
    connectionUser: null,
    connectionPassword: null,
    deviceToken: 'abc',
  );

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
        OneSignalPrivacyInitial(),
        OneSignalPrivacyConsentSuccess(),
      ];
      expectLater(bloc, emitsInOrder(expected));
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
        OneSignalPrivacyInitial(),
        OneSignalPrivacyConsentFailure(),
      ];
      expectLater(bloc, emitsInOrder(expected));
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
          OneSignalPrivacyInitial(),
          OneSignalPrivacyConsentSuccess(),
        ];
        expectLater(bloc, emitsInOrder(expected));
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
      when(mockGetSettings.load()).thenAnswer((_) async => tSettingsModel);
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
          OneSignalPrivacyInitial(),
          OneSignalPrivacyConsentFailure(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(OneSignalPrivacyRevokeConsent());
      },
    );
  });
}
