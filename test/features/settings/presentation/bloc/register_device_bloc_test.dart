import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/register_device_bloc.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  MockRegisterDevice mockRegisterDevice;
  MockSettingsBloc mockSettingsBloc;
  MockLogging mockLogging;
  MockSettings mockSettings;
  RegisterDeviceBloc bloc;

  setUp(() {
    mockRegisterDevice = MockRegisterDevice();
    mockSettingsBloc = MockSettingsBloc();
    mockLogging = MockLogging();
    mockSettings = MockSettings();

    bloc = RegisterDeviceBloc(
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
      settings: mockSettings,
    );
  });

  final String tQrCodeResult =
      'http://tautulli.com|abcdefghijklmnopqrstuvwxyzabcdef';
  final int tId = 1;
  final String tPrimaryConnectionAddress = 'http://tautulli.com';
  final String tPrimaryConnectionProtocol = 'http';
  final String tPrimaryConnectionDomain = 'tautulli.com';
  final String tPrimaryConnectionPath = '/tautulli';
  final String tDeviceToken = 'abc';
  final String tTautulliId = 'jkl';
  final String tPlexName = 'Plex';
  final String tPlexIdentifier = 'xyz';

  final Map<String, String> tPrimaryConnectionMap = {
    'protocol': tPrimaryConnectionProtocol,
    'domain': tPrimaryConnectionDomain,
    'user': tPrimaryConnectionPath,
  };

  final ServerModel tServerModel = ServerModel(
    id: tId,
    primaryConnectionAddress: tPrimaryConnectionAddress,
    primaryConnectionProtocol: tPrimaryConnectionDomain,
    primaryConnectionDomain: tPrimaryConnectionDomain,
    primaryConnectionPath: tPrimaryConnectionPath,
    deviceToken: tDeviceToken,
    tautulliId: tTautulliId,
    plexName: tPlexName,
    plexIdentifier: tPlexIdentifier,
    primaryActive: true,
    plexPass: true,
  );

  Map responseMap = {
    "data": {
      "pms_name": "Starlight",
      "server_id": "jkl",
      "pms_plexpass": 1,
    }
  };

  void setUpSuccess() {
    when(
      mockRegisterDevice(
        connectionProtocol: anyNamed('connectionProtocol'),
        connectionDomain: anyNamed('connectionDomain'),
        connectionPath: anyNamed('connectionPath'),
        deviceToken: anyNamed('deviceToken'),
        trustCert: anyNamed('trustCert'),
      ),
    ).thenAnswer((_) async => Right(responseMap));
  }

  test(
    'initialState should be RegisterDeviceInitial',
    () async {
      // assert
      expect(bloc.state, RegisterDeviceInitial());
    },
  );

  group('QR code scanner', () {
    test(
      'should call RegisterDevice usecase',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          RegisterDeviceFromQrStarted(
            result: tQrCodeResult,
            settingsBloc: mockSettingsBloc,
          ),
        );
        await untilCalled(
          mockRegisterDevice(
            connectionProtocol: anyNamed('connectionProtocol'),
            connectionDomain: anyNamed('connectionDomain'),
            connectionPath: anyNamed('connectionPath'),
            deviceToken: anyNamed('deviceToken'),
            trustCert: anyNamed('trustCert'),
          ),
        );
        // assert
        verify(
          mockRegisterDevice(
            connectionProtocol: anyNamed('connectionProtocol'),
            connectionDomain: anyNamed('connectionDomain'),
            connectionPath: anyNamed('connectionPath'),
            deviceToken: anyNamed('deviceToken'),
            trustCert: anyNamed('trustCert'),
          ),
        );
      },
    );

    //TODO: Testing is timing out on settingsBloc.add(), possible because it is not a dependency
    // test(
    //   'should verify if the server is already stored in the database',
    //   () async {
    //     // arrange
    //     setUpSuccess();
    //     when(mockSettings.getServerByTautulliId(any))
    //         .thenAnswer((_) async => tServerModel);
    //     // act
    //     bloc.add(
    //       RegisterDeviceFromQrStarted(
    //         result: tQrCodeResult,
    //         settingsBloc: mockSettingsBloc,
    //       ),
    //     );
    //     await untilCalled(mockSettings.getServerByTautulliId(tTautulliId));
    //     // assert
    //     verify(mockSettings.getServerByTautulliId(tTautulliId));
    //   },
    // );

    //TODO: Need to test for if the server is not in the db and we add a new one

    //TODO: Need to test for if the server is in the db and we do an update

    test(
      'should emit [RegisterDeviceInProgress, RegisterDeviceFailure] when QR code data is incorrect',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          RegisterDeviceInProgress(),
          RegisterDeviceFailure(
            failure: QRScanFailure(),
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          RegisterDeviceFromQrStarted(
            result: 'http://tautulli.con|abc',
            settingsBloc: mockSettingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [RegisterDeviceInProgress, RegisterDeviceSuccess] when device is successfully registered',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          RegisterDeviceInProgress(),
          RegisterDeviceSuccess(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          RegisterDeviceFromQrStarted(
            result: tQrCodeResult,
            settingsBloc: mockSettingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [RegisterDeviceInProgress, RegisterDeviceFailure] when device fails to register',
      () async {
        // arrange
        when(
          mockRegisterDevice(
            connectionProtocol: anyNamed('connectionProtocol'),
            connectionDomain: anyNamed('connectionDomain'),
            connectionPath: anyNamed('connectionPath'),
            deviceToken: anyNamed('deviceToken'),
            trustCert: anyNamed('trustCert'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          RegisterDeviceInProgress(),
          RegisterDeviceFailure(failure: ServerFailure()),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          RegisterDeviceFromQrStarted(
            result: tQrCodeResult,
            settingsBloc: mockSettingsBloc,
          ),
        );
      },
    );
  });

  group('manually', () {
    test(
      'should call RegisterDevice usecase',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          RegisterDeviceManualStarted(
            connectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            settingsBloc: mockSettingsBloc,
          ),
        );
        await untilCalled(
          mockRegisterDevice(
            connectionProtocol: anyNamed('connectionProtocol'),
            connectionDomain: anyNamed('connectionDomain'),
            connectionPath: anyNamed('connectionPath'),
            deviceToken: anyNamed('deviceToken'),
            trustCert: anyNamed('trustCert'),
          ),
        );
        // assert
        verify(
          mockRegisterDevice(
            connectionProtocol: anyNamed('connectionProtocol'),
            connectionDomain: anyNamed('connectionDomain'),
            connectionPath: anyNamed('connectionPath'),
            deviceToken: anyNamed('deviceToken'),
            trustCert: anyNamed('trustCert'),
          ),
        );
      },
    );

    //TODO: Testing is timing out when waiting for getServerbyTautulliId
    // test(
    //   'should verify if the server is already stored in the database',
    //   () async {
    //     // arrange
    //     setUpSuccess();
    //     when(mockSettings.getServerByTautulliId(any))
    //         .thenAnswer((_) async => tServerModel);
    //     // act
    //     bloc.add(
    //       RegisterDeviceManualStarted(
    //         connectionAddress: tPrimaryConnectionAddress,
    //         deviceToken: tDeviceToken,
    //         settingsBloc: mockSettingsBloc,
    //       ),
    //     );
    //     await untilCalled(mockSettings.getServerByTautulliId(tTautulliId));
    //     // assert
    //     verify(mockSettings.getServerByTautulliId(tTautulliId));
    //   },
    // );

    //TODO: Need to test for if the server is not in the db and we add a new one

    //TODO: Need to test for if the server is in the db and we do an update

    test(
      'should emit [RegisterDeviceInProgress, RegisterDeviceSuccess] when device is successfully registered',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          RegisterDeviceInProgress(),
          RegisterDeviceSuccess(),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          RegisterDeviceManualStarted(
            connectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            settingsBloc: mockSettingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [RegisterDeviceInProgress, RegisterDeviceFailure] when device fails to register',
      () async {
        // arrange
        when(
          mockRegisterDevice(
            connectionProtocol: anyNamed('connectionProtocol'),
            connectionDomain: anyNamed('connectionDomain'),
            connectionPath: anyNamed('connectionPath'),
            deviceToken: anyNamed('deviceToken'),
            trustCert: anyNamed('trustCert'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          RegisterDeviceInProgress(),
          RegisterDeviceFailure(failure: ServerFailure()),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          RegisterDeviceManualStarted(
            connectionAddress: tPrimaryConnectionAddress,
            deviceToken: tDeviceToken,
            settingsBloc: mockSettingsBloc,
          ),
        );
      },
    );
  });

  // test(
  //   'should save connectionAddress to settings when device is successfully registered',
  //   () async {
  //     // arrange
  //     setUpSuccess();
  //     // act
  //     bloc.add(RegisterDeviceFromQrStarted(result: qrCodeResult));
  //     await untilCalled(mockSetSettings.setConnectionAddress(any));
  //     // assert
  //     verify(mockSetSettings.setConnectionAddress(connectionAddress));
  //   },
  // );

  //TODO: Tests are timing out on settingsBloc.add(), possible because it is not a dependency
  // test(
  //   'should save server details to settings when device is successfully registered',
  //   () async {
  //     // arrange
  //     setUpSuccess();
  //     when(mockSettings.getServerByTautulliId(any))
  //         .thenAnswer((_) async => null);
  //     // act
  //     bloc.add(
  //       RegisterDeviceFromQrStarted(
  //         result: tQrCodeResult,
  //         settingsBloc: mockSettingsBloc,
  //       ),
  //     );
  //     await untilCalled(
  //       mockSettingsBloc.add(
  //         SettingsAddServer(
  //           primaryConnectionAddress: tPrimaryConnectionAddress,
  //           deviceToken: tDeviceToken,
  //           plexName: tPlexName,
  //           tautulliId: tTautulliId,
  //         ),
  //       ),
  //     );
  //     // assert
  //     verify(
  //       mockSettingsBloc.add(
  //         SettingsAddServer(
  //           primaryConnectionAddress: tPrimaryConnectionAddress,
  //           deviceToken: tDeviceToken,
  //           plexName: tPlexName,
  //           tautulliId: tTautulliId,
  //         ),
  //       ),
  //     );
  //   },
  // );

  // test(
  //   'should save deviceToken to settings when device is successfully registered',
  //   () async {
  //     // arrange
  //     setUpSuccess();
  //     // act
  //     bloc.add(
  //       RegisterDeviceFromQrStarted(
  //         result: tQrCodeResult,
  //         settingsBloc: mockSettingsBloc,
  //       ),
  //     );
  //     await untilCalled(
  //       mockSettingsBloc.add(
  //         SettingsUpdateDeviceToken(
  //           id: tId,
  //           deviceToken: tDeviceToken,
  //         ),
  //       ),
  //     );
  //     // assert
  //     verify(
  //       mockSettingsBloc.add(
  //         SettingsUpdateDeviceToken(
  //           id: tId,
  //           deviceToken: tDeviceToken,
  //         ),
  //       ),
  //     );
  //   },
  // );
}
