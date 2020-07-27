import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/database/data/models/server_model.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/connection_address_helper.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote_tdd/features/settings/presentation/bloc/register_device_bloc.dart';
import 'package:tautulli_remote_tdd/features/settings/presentation/bloc/settings_bloc.dart';

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockSettings extends Mock implements Settings {}

class MockConnectionAddressHelper extends Mock
    implements ConnectionAddressHelper {}

class MockLogging extends Mock implements Logging {}

void main() {
  MockRegisterDevice mockRegisterDevice;
  MockConnectionAddressHelper mockConnectionAddressHelper;
  MockSettingsBloc mockSettingsBloc;
  MockLogging mockLogging;
  MockSettings mockSettings;
  RegisterDeviceBloc bloc;

  setUp(() {
    mockRegisterDevice = MockRegisterDevice();
    mockSettingsBloc = MockSettingsBloc();
    mockConnectionAddressHelper = MockConnectionAddressHelper();
    mockLogging = MockLogging();
    mockSettings = MockSettings();

    bloc = RegisterDeviceBloc(
      registerDevice: mockRegisterDevice,
      connectionAddressHelper: mockConnectionAddressHelper,
      logging: mockLogging,
      settings: mockSettings,
    );
  });

  final String tQrCodeResult = 'http://tautulli.com|abc';
  final int tId = 1;
  final String tPrimaryConnectionAddress = 'http://tautulli.com';
  final String tPrimaryConnectionProtocol = 'http';
  final String tPrimaryConnectionDomain = 'tautulli.com';
  final String tPrimaryConnectionUser = 'user';
  final String tPrimaryConnectionPassword = 'pass';
  final String tDeviceToken = 'abc';
  final String tTautulliId = 'jkl';
  final String tPlexName = 'Plex';

  final Map<String, String> tPrimaryConnectionMap = {
    'protocol': tPrimaryConnectionProtocol,
    'domain': tPrimaryConnectionDomain,
    'user': tPrimaryConnectionUser,
    'password': tPrimaryConnectionPassword,
  };

  final ServerModel tServerModel = ServerModel(
    id: tId,
    primaryConnectionAddress: tPrimaryConnectionAddress,
    primaryConnectionProtocol: tPrimaryConnectionDomain,
    primaryConnectionDomain: tPrimaryConnectionDomain,
    primaryConnectionUser: tPrimaryConnectionUser,
    primaryConnectionPassword: tPrimaryConnectionPassword,
    deviceToken: tDeviceToken,
    tautulliId: tTautulliId,
    plexName: tPlexName,
  );

  Map responseMap = {
    "data": {"pms_name": "Starlight", "server_id": "jkl"}
  };

  void setUpSuccess() {
    when(
      mockRegisterDevice(
        connectionProtocol: anyNamed('connectionProtocol'),
        connectionDomain: anyNamed('connectionDomain'),
        connectionUser: anyNamed('connectionUser'),
        connectionPassword: anyNamed('connectionPassword'),
        deviceToken: anyNamed('deviceToken'),
      ),
    ).thenAnswer((_) async => Right(responseMap));
    when(mockConnectionAddressHelper.parse(tPrimaryConnectionAddress))
        .thenReturn(tPrimaryConnectionMap);
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
      'should call connectionAddressHelper.parse() to parse connectionAddress into connection details',
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
        await untilCalled(mockConnectionAddressHelper.parse(any));
        // assert
        verify(mockConnectionAddressHelper.parse(tPrimaryConnectionAddress));
      },
    );

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
            connectionUser: anyNamed('connectionUser'),
            connectionPassword: anyNamed('connectionPassword'),
            deviceToken: anyNamed('deviceToken'),
          ),
        );
        // assert
        verify(
          mockRegisterDevice(
            connectionProtocol: tPrimaryConnectionProtocol,
            connectionDomain: tPrimaryConnectionDomain,
            connectionUser: tPrimaryConnectionUser,
            connectionPassword: tPrimaryConnectionPassword,
            deviceToken: tDeviceToken,
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
      'should emit [RegisterDeviceInProgress, RegisterDeviceSuccess] when device is successfully registered',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          RegisterDeviceInitial(),
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
            connectionUser: anyNamed('connectionUser'),
            connectionPassword: anyNamed('connectionPassword'),
            deviceToken: anyNamed('deviceToken'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure()));
        when(mockConnectionAddressHelper.parse(tPrimaryConnectionAddress))
            .thenReturn(tPrimaryConnectionMap);
        // assert later
        final expected = [
          RegisterDeviceInitial(),
          RegisterDeviceInProgress(),
          RegisterDeviceFailure(),
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
            connectionUser: anyNamed('connectionUser'),
            connectionPassword: anyNamed('connectionPassword'),
            deviceToken: anyNamed('deviceToken'),
          ),
        );
        // assert
        verify(
          mockRegisterDevice(
            connectionProtocol: tPrimaryConnectionProtocol,
            connectionDomain: tPrimaryConnectionDomain,
            connectionUser: tPrimaryConnectionUser,
            connectionPassword: tPrimaryConnectionPassword,
            deviceToken: tDeviceToken,
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
          RegisterDeviceInitial(),
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
            connectionUser: anyNamed('connectionUser'),
            connectionPassword: anyNamed('connectionPassword'),
            deviceToken: anyNamed('deviceToken'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure()));
        when(mockConnectionAddressHelper.parse(tPrimaryConnectionAddress))
            .thenReturn(tPrimaryConnectionMap);
        // assert later
        final expected = [
          RegisterDeviceInitial(),
          RegisterDeviceInProgress(),
          RegisterDeviceFailure(),
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
