import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/database/data/models/server_model.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettings extends Mock implements Settings {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockOneSignal extends Mock implements OneSignalDataSource {}

class MockLogging extends Mock implements Logging {}

void main() {
  SettingsBloc bloc;
  MockSettings mockSettings;
  MockRegisterDevice mockRegisterDevice;
  MockOneSignal mockOneSignal;
  MockLogging mockLogging;

  setUp(() {
    mockSettings = MockSettings();
    mockRegisterDevice = MockRegisterDevice();
    mockOneSignal = MockOneSignal();
    mockLogging = MockLogging();

    bloc = SettingsBloc(
      settings: mockSettings,
      registerDevice: mockRegisterDevice,
      onesignal: mockOneSignal,
      logging: mockLogging,
    );
  });

  const String tPrimaryConnectionAddress = 'http://tautulli.com/tautulli';
  const String tPrimaryConnectionProtocol = 'http';
  const String tPrimaryConnectionDomain = 'tautulli.com';
  const String tPrimaryConnectionPath = '/tautulli';
  const String tSecondaryConnectionAddress = 'http://plexpy.com/plexpy';
  const String tSecondaryConnectionProtocol = 'http';
  const String tSecondaryConnectionDomain = 'plexpy.com';
  const String tSecondaryConnectionPath = '/plexpy';
  const String tDeviceToken = 'abc';
  const String tDeviceToken2 = 'adef';
  const String tTautulliId = 'jkl';
  const String tTautulliId2 = 'mno';
  const String tPlexName = 'Plex';
  const String tPlexName2 = 'Plex2';
  const String tPlexIdentifier = 'uvw';
  const String tPlexIdentifier2 = 'xyz';
  const String tDateFormat = 'YYYY-MM-DD';
  const String tTimeFormat = 'HH:mm';

  final ServerModel tServerModel = ServerModel(
    primaryConnectionAddress: tPrimaryConnectionAddress,
    primaryConnectionProtocol: tPrimaryConnectionProtocol,
    primaryConnectionDomain: tPrimaryConnectionDomain,
    primaryConnectionPath: tPrimaryConnectionPath,
    deviceToken: tDeviceToken,
    tautulliId: tTautulliId,
    plexName: tPlexName,
    plexIdentifier: tPlexIdentifier,
    primaryActive: true,
    onesignalRegistered: false,
    plexPass: true,
    sortIndex: 0,
  );

  final ServerModel tServerModel2 = ServerModel(
    primaryConnectionAddress: tSecondaryConnectionAddress,
    primaryConnectionProtocol: tSecondaryConnectionProtocol,
    primaryConnectionDomain: tSecondaryConnectionDomain,
    primaryConnectionPath: tSecondaryConnectionPath,
    deviceToken: tDeviceToken2,
    tautulliId: tTautulliId2,
    plexName: tPlexName2,
    plexIdentifier: tPlexIdentifier2,
    primaryActive: true,
    onesignalRegistered: true,
    plexPass: true,
    sortIndex: 1,
  );

  final Map<String, dynamic> tTautulliSettings = {
    'general': TautulliSettingsGeneralModel(
      dateFormat: tDateFormat,
      timeFormat: tTimeFormat,
    ),
  };

  final List<ServerModel> tServerList = [tServerModel];
  final List<ServerModel> tUpdatedServerList = [tServerModel, tServerModel2];

  const int tServerTimeout = 5;
  const int tRefreshRate = 10;
  const bool tDoubleTapToExit = true;
  const bool tMaskSensitiveInfo = true;
  const String tStatsType = 'duration';
  const String tYAxis = 'duration';
  const String tUsersSort = 'friendly_name|asc';
  const bool tOneSignalBannerDismissed = false;
  const String oneSignalUserId = 'abd';

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  Map registerDeviceResponseMap = {
    "data": {
      "pms_name": "Starlight",
      "server_id": "jkl",
      "pms_plexpass": 1,
    }
  };

  void setUpSuccess({bool updatedServerList = false}) {
    when(mockSettings.getAllServers()).thenAnswer(
        (_) async => updatedServerList ? tUpdatedServerList : tServerList);
    when(mockSettings.getServerTimeout())
        .thenAnswer((_) async => tServerTimeout);
    when(mockSettings.getRefreshRate()).thenAnswer((_) async => tRefreshRate);
    when(mockSettings.getDoubleTapToExit())
        .thenAnswer((_) async => tDoubleTapToExit);
    when(mockSettings.getMaskSensitiveInfo())
        .thenAnswer((_) async => tMaskSensitiveInfo);
    when(mockSettings.getLastSelectedServer())
        .thenAnswer((_) async => tTautulliId);
    when(mockSettings.getStatsType()).thenAnswer((_) async => tStatsType);
    when(mockSettings.getYAxis()).thenAnswer((_) async => tYAxis);
    when(mockSettings.getPlexServerInfo(
      tautulliId: anyNamed('tautulliId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlexServerInfo));
    when(mockSettings.getTautulliSettings(
      tautulliId: anyNamed('tautulliId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tTautulliSettings));
    when(mockOneSignal.userId).thenAnswer((_) async => oneSignalUserId);
    when(
      mockRegisterDevice(
        connectionProtocol: anyNamed('connectionProtocol'),
        connectionDomain: anyNamed('connectionDomain'),
        connectionPath: anyNamed('connectionPath'),
        deviceToken: anyNamed('deviceToken'),
        trustCert: anyNamed('trustCert'),
      ),
    ).thenAnswer((_) async => Right(registerDeviceResponseMap));
  }

  test(
    'initialState should be SettingsInitial',
    () async {
      // assert
      expect(bloc.state, SettingsInitial());
    },
  );

  group('SettingsLoad', () {
    test(
      'should get SettingsModel from the Settings.getAllServers() use case',
      () async {
        // arrange
        when(mockSettings.getAllServers()).thenAnswer((_) async => tServerList);
        // act
        bloc.add(SettingsLoad(settingsBloc: bloc));
        await untilCalled(mockSettings.getAllServers());
        // assert
        verify(mockSettings.getAllServers());
      },
    );

    test(
      'should emit [SettingsLoadInProgress, SettingsLoadSuccess] when Settings are loaded successfully',
      () async {
        // arrange
        setUpSuccess();
        // assert later
        final expected = [
          SettingsLoadInProgress(),
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(SettingsLoad(settingsBloc: bloc));
      },
    );
  });

  group('state is SettingsLoadSuccess', () {
    group('SettingsAddServer', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
        when(
          mockSettings.getServerByTautulliId(tTautulliId2),
        ).thenAnswer((_) async => tServerModel2);
      });
      test(
        'should call Settings.addServer() use case',
        () async {
          // arrange
          setUpSuccess();
          // act
          bloc.add(
            SettingsAddServer(
              primaryConnectionAddress: tSecondaryConnectionAddress,
              deviceToken: tDeviceToken2,
              tautulliId: tTautulliId2,
              plexName: tPlexName2,
              plexIdentifier: tPlexIdentifier2,
              plexPass: true,
            ),
          );
          await untilCalled(
            mockSettings.addServer(
              server: tServerModel2,
            ),
          );
          // assert
          verify(
            mockSettings.addServer(
              server: tServerModel2,
            ),
          );
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after adding a server',
        () async {
          // arrange
          setUpSuccess(updatedServerList: true);
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tUpdatedServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsAddServer(
              primaryConnectionAddress: tSecondaryConnectionAddress,
              deviceToken: tDeviceToken2,
              tautulliId: tTautulliId2,
              plexName: tPlexName2,
              plexIdentifier: tPlexIdentifier2,
              plexPass: true,
            ),
          );
        },
      );
    });

    group('SettingsUpdateServer', () {
      setUp(() {
        List<ServerModel> newList = [
          tServerModel.copyWith(id: 0),
        ];
        bloc.emit(
          SettingsLoadSuccess(
            serverList: newList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.updateServerById() use case',
        () async {
          // act
          bloc.add(
            SettingsUpdateServer(
              id: 0,
              sortIndex: 0,
              primaryConnectionAddress: tPrimaryConnectionAddress,
              secondaryConnectionAddress: tSecondaryConnectionAddress,
              deviceToken: tDeviceToken,
              tautulliId: tTautulliId,
              plexName: tPlexName,
              plexIdentifier: tPlexIdentifier,
              plexPass: true,
              timeFormat: tTimeFormat,
              dateFormat: tDateFormat,
            ),
          );
          await untilCalled(
            mockSettings.updateServerById(
              server: tServerModel.copyWith(
                id: 0,
                timeFormat: tTimeFormat,
                dateFormat: tDateFormat,
                secondaryConnectionAddress: tSecondaryConnectionAddress,
                secondaryConnectionPath: tSecondaryConnectionPath,
                secondaryConnectionProtocol: tSecondaryConnectionProtocol,
                secondaryConnectionDomain: tSecondaryConnectionDomain,
              ),
            ),
          );
          // assert
          verify(
            mockSettings.updateServerById(
              server: tServerModel.copyWith(
                id: 0,
                timeFormat: tTimeFormat,
                dateFormat: tDateFormat,
                secondaryConnectionAddress: tSecondaryConnectionAddress,
                secondaryConnectionPath: tSecondaryConnectionPath,
                secondaryConnectionProtocol: tSecondaryConnectionProtocol,
                secondaryConnectionDomain: tSecondaryConnectionDomain,
              ),
            ),
          );
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating a server',
        () async {
          // arrange
          List<ServerModel> newList = [
            tServerModel.copyWith(
              id: 0,
              timeFormat: tTimeFormat,
              dateFormat: tDateFormat,
              secondaryConnectionAddress: tSecondaryConnectionAddress,
              secondaryConnectionPath: tSecondaryConnectionPath,
              secondaryConnectionProtocol: tSecondaryConnectionProtocol,
              secondaryConnectionDomain: tSecondaryConnectionDomain,
            ),
          ];
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: newList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsUpdateServer(
              id: 0,
              sortIndex: 0,
              primaryConnectionAddress: tPrimaryConnectionAddress,
              secondaryConnectionAddress: tSecondaryConnectionAddress,
              deviceToken: tDeviceToken,
              tautulliId: tTautulliId,
              plexName: tPlexName,
              plexIdentifier: tPlexIdentifier,
              plexPass: true,
              timeFormat: tTimeFormat,
              dateFormat: tDateFormat,
            ),
          );
        },
      );
    });
    group('SettingsDeleteServer', () {
      setUp(() {
        List<ServerModel> newList = [
          tServerModel.copyWith(id: 0),
          tServerModel2.copyWith(id: 1),
        ];
        bloc.emit(
          SettingsLoadSuccess(
            serverList: newList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.deleteServer() use case',
        () async {
          // act
          bloc.add(
            SettingsDeleteServer(
              id: 1,
              plexName: tPlexName2,
            ),
          );
          await untilCalled(mockSettings.deleteServer(1));
          // assert
          verify(mockSettings.deleteServer(1));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after deleting a server',
        () async {
          // arrange
          List<ServerModel> newList = [tServerModel.copyWith(id: 0)];
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: newList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsDeleteServer(
              id: 1,
              plexName: tPlexName2,
            ),
          );
        },
      );
    });
    group('SettingsUpdatePrimaryConnection', () {
      setUp(() {
        List<ServerModel> newList = [
          tServerModel.copyWith(id: 0),
        ];
        bloc.emit(
          SettingsLoadSuccess(
            serverList: newList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.updatePrimaryConnection() use case',
        () async {
          // act
          bloc.add(
            SettingsUpdatePrimaryConnection(
              id: 0,
              primaryConnectionAddress: tSecondaryConnectionAddress,
              plexName: tPlexName,
            ),
          );
          await untilCalled(
            mockSettings.updatePrimaryConnection(
              id: 0,
              primaryConnectionInfo: {
                'primary_connection_address': tSecondaryConnectionAddress,
                'primary_connection_protocol': tSecondaryConnectionProtocol,
                'primary_connection_domain': tSecondaryConnectionDomain,
                'primary_connection_path': tSecondaryConnectionPath,
              },
            ),
          );
          // assert
          verify(
            mockSettings.updatePrimaryConnection(
              id: 0,
              primaryConnectionInfo: {
                'primary_connection_address': tSecondaryConnectionAddress,
                'primary_connection_protocol': tSecondaryConnectionProtocol,
                'primary_connection_domain': tSecondaryConnectionDomain,
                'primary_connection_path': tSecondaryConnectionPath,
              },
            ),
          );
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating a primary connection',
        () async {
          // arrange
          List<ServerModel> newList = [
            tServerModel.copyWith(
              id: 0,
              primaryConnectionAddress: tSecondaryConnectionAddress,
              primaryConnectionProtocol: tSecondaryConnectionProtocol,
              primaryConnectionDomain: tSecondaryConnectionDomain,
              primaryConnectionPath: tSecondaryConnectionPath,
            ),
          ];
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: newList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsUpdatePrimaryConnection(
              id: 0,
              primaryConnectionAddress: tSecondaryConnectionAddress,
              plexName: tPlexName,
            ),
          );
        },
      );
    });
    group('SettingsUpdateSecondaryAddress', () {
      setUp(() {
        List<ServerModel> newList = [
          tServerModel.copyWith(id: 0),
        ];
        bloc.emit(
          SettingsLoadSuccess(
            serverList: newList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.updateSecondaryConnection() use case',
        () async {
          // act
          bloc.add(
            SettingsUpdateSecondaryConnection(
              id: 0,
              secondaryConnectionAddress: tSecondaryConnectionAddress,
              plexName: tPlexName,
            ),
          );
          await untilCalled(
            mockSettings.updateSecondaryConnection(
              id: 0,
              secondaryConnectionInfo: {
                'secondary_connection_address': tSecondaryConnectionAddress,
                'secondary_connection_protocol': tSecondaryConnectionProtocol,
                'secondary_connection_domain': tSecondaryConnectionDomain,
                'secondary_connection_path': tSecondaryConnectionPath,
              },
            ),
          );
          // assert
          verify(
            mockSettings.updateSecondaryConnection(
              id: 0,
              secondaryConnectionInfo: {
                'secondary_connection_address': tSecondaryConnectionAddress,
                'secondary_connection_protocol': tSecondaryConnectionProtocol,
                'secondary_connection_domain': tSecondaryConnectionDomain,
                'secondary_connection_path': tSecondaryConnectionPath,
              },
            ),
          );
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating a secondary connection',
        () async {
          // arrange
          List<ServerModel> newList = [
            tServerModel.copyWith(
              id: 0,
              secondaryConnectionAddress: tSecondaryConnectionAddress,
              secondaryConnectionProtocol: tSecondaryConnectionProtocol,
              secondaryConnectionDomain: tSecondaryConnectionDomain,
              secondaryConnectionPath: tSecondaryConnectionPath,
            ),
          ];
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: newList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsUpdateSecondaryConnection(
              id: 0,
              secondaryConnectionAddress: tSecondaryConnectionAddress,
              plexName: tPlexName,
            ),
          );
        },
      );
    });
    group('SettingsUpdatePrimaryActive', () {
      setUp(() {
        List<ServerModel> newList = [
          tServerModel.copyWith(id: 0),
        ];
        bloc.emit(
          SettingsLoadSuccess(
            serverList: newList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.updatePrimaryActive() use case',
        () async {
          // act
          bloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tTautulliId,
              primaryActive: false,
            ),
          );
          await untilCalled(
            mockSettings.updatePrimaryActive(
              tautulliId: tTautulliId,
              primaryActive: false,
            ),
          );
          // assert
          verify(
            mockSettings.updatePrimaryActive(
              tautulliId: tTautulliId,
              primaryActive: false,
            ),
          );
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating primary active',
        () async {
          // arrange
          List<ServerModel> newList = [
            tServerModel.copyWith(
              id: 0,
              primaryActive: false,
            ),
          ];
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: newList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tTautulliId,
              primaryActive: false,
            ),
          );
        },
      );
    });
    group('SettingsUpdateSortIndex', () {
      setUp(() {
        List<ServerModel> newList = [
          tServerModel.copyWith(id: 0),
          tServerModel2.copyWith(id: 1),
        ];
        bloc.emit(
          SettingsLoadSuccess(
            serverList: newList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.updateServerSort() use case',
        () async {
          // act
          bloc.add(
            SettingsUpdateSortIndex(
              serverId: 0,
              oldIndex: 0,
              newIndex: 1,
            ),
          );
          await untilCalled(
            mockSettings.updateServerSort(
              serverId: 0,
              oldIndex: 0,
              newIndex: 1,
            ),
          );
          // assert
          verify(
            mockSettings.updateServerSort(
              serverId: 0,
              oldIndex: 0,
              newIndex: 1,
            ),
          );
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating the server sort',
        () async {
          // arrange
          List<ServerModel> newList = [
            tServerModel2.copyWith(id: 1),
            tServerModel.copyWith(id: 0),
          ];
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: newList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
              sortChanged: '0:0:1',
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsUpdateSortIndex(
              serverId: 0,
              oldIndex: 0,
              newIndex: 1,
            ),
          );
        },
      );
    });
    group('SettingsUpdateServerTimeOut', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setServerTimeout() use case',
        () async {
          // act
          bloc.add(
            SettingsUpdateServerTimeout(
              timeout: 3,
            ),
          );
          await untilCalled(
            mockSettings.setServerTimeout(3),
          );
          // assert
          verify(
            mockSettings.setServerTimeout(3),
          );
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after setting the server timeout',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: 3,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsUpdateServerTimeout(
              timeout: 3,
            ),
          );
        },
      );
    });
    group('SettingsUpdateRefreshRate', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setRefreshRate() use case',
        () async {
          // act
          bloc.add(
            SettingsUpdateRefreshRate(refreshRate: 10),
          );
          await untilCalled(mockSettings.setRefreshRate(10));
          // assert
          verify(mockSettings.setRefreshRate(10));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after setting the refresh rate',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: 5,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(
            SettingsUpdateRefreshRate(refreshRate: 5),
          );
        },
      );
    });
    group('SettingsUpdateDoubleTapToExit', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setDoubleTapToExit() use case',
        () async {
          // act
          bloc.add(SettingsUpdateDoubleTapToExit(value: false));
          await untilCalled(mockSettings.setDoubleTapToExit(false));
          // assert
          verify(mockSettings.setDoubleTapToExit(false));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating double tap to exit',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: false,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(SettingsUpdateDoubleTapToExit(value: false));
        },
      );
    });
    group('SettingsMaskSensitiveInfo', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setMaskSensitiveInfo() use case',
        () async {
          // act
          bloc.add(SettingsUpdateMaskSensitiveInfo(value: false));
          await untilCalled(mockSettings.setMaskSensitiveInfo(false));
          // assert
          verify(mockSettings.setMaskSensitiveInfo(false));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating mask sensitive info',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: false,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(SettingsUpdateMaskSensitiveInfo(value: false));
        },
      );
    });
    group('SettingsUpdateLastSelectedServer', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setLastSelectedServer() use case',
        () async {
          // act
          bloc.add(SettingsUpdateLastSelectedServer(tautulliId: tTautulliId2));
          await untilCalled(mockSettings.setLastSelectedServer(tTautulliId2));
          // assert
          verify(mockSettings.setLastSelectedServer(tTautulliId2));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating the last selected server',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId2,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(SettingsUpdateLastSelectedServer(tautulliId: tTautulliId2));
        },
      );
    });
    group('SettingsUpdateStatsType', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setStatsType() use case',
        () async {
          // act
          bloc.add(SettingsUpdateStatsType(statsType: 'plays'));
          await untilCalled(mockSettings.setStatsType('plays'));
          // assert
          verify(mockSettings.setStatsType('plays'));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating the stats type',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: 'plays',
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(SettingsUpdateStatsType(statsType: 'plays'));
        },
      );
    });
    group('SettingsUpdateYAxis', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setYAxis() use case',
        () async {
          // act
          bloc.add(SettingsUpdateYAxis(yAxis: 'plays'));
          await untilCalled(mockSettings.setYAxis('plays'));
          // assert
          verify(mockSettings.setYAxis('plays'));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating the y axis',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: 'plays',
              usersSort: tUsersSort,
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(SettingsUpdateYAxis(yAxis: 'plays'));
        },
      );
    });
    group('SettingsUpdateUsersSort', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setUsersSort() use case',
        () async {
          // act
          bloc.add(SettingsUpdateUsersSort(usersSort: 'friendly_name|asc'));
          await untilCalled(mockSettings.setUsersSort('friendly_name|asc'));
          // assert
          verify(mockSettings.setUsersSort('friendly_name|asc'));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating the stats type',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: 'friendly_name|desc',
              oneSignalBannerDismissed: tOneSignalBannerDismissed,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(SettingsUpdateUsersSort(usersSort: 'friendly_name|desc'));
        },
      );
    });
    group('SettingsUpdateOneSignalBannerDismiss', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setOneSignalBannerDismissed() use case',
        () async {
          // act
          bloc.add(SettingsUpdateOneSignalBannerDismiss(true));
          await untilCalled(mockSettings.setOneSignalBannerDismissed(true));
          // assert
          verify(mockSettings.setOneSignalBannerDismissed(true));
        },
      );
      test(
        'should emit [SettingsLoadSuccess] after updating the stats type',
        () async {
          // assert later
          final expected = [
            SettingsLoadSuccess(
              serverList: tServerList,
              serverTimeout: tServerTimeout,
              refreshRate: tRefreshRate,
              doubleTapToExit: tDoubleTapToExit,
              maskSensitiveInfo: tMaskSensitiveInfo,
              lastSelectedServer: tTautulliId,
              statsType: tStatsType,
              yAxis: tYAxis,
              usersSort: tUsersSort,
              oneSignalBannerDismissed: true,
            ),
          ];
          // ignore: unawaited_futures
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(SettingsUpdateOneSignalBannerDismiss(true));
        },
      );
    });
    group('SettingsUpdateWizardCompleteStatus', () {
      setUp(() {
        bloc.emit(
          SettingsLoadSuccess(
            serverList: tServerList,
            serverTimeout: tServerTimeout,
            refreshRate: tRefreshRate,
            doubleTapToExit: tDoubleTapToExit,
            maskSensitiveInfo: tMaskSensitiveInfo,
            lastSelectedServer: tTautulliId,
            statsType: tStatsType,
            yAxis: tYAxis,
            usersSort: tUsersSort,
            oneSignalBannerDismissed: tOneSignalBannerDismissed,
          ),
        );
      });
      test(
        'should call the Settings.setWizardCompleteStatus() use case',
        () async {
          // act
          bloc.add(SettingsUpdateWizardCompleteStatus(true));
          await untilCalled(mockSettings.setWizardCompleteStatus(true));
          // assert
          verify(mockSettings.setWizardCompleteStatus(true));
        },
      );
    });
    //TODO: Issues with test since it replies on PackageInfo
    // group('SettingsUpdateLastAppVersion', () {
    //   setUp(() {
    //     bloc.emit(
    //       SettingsLoadSuccess(
    //         serverList: tServerList,
    //         serverTimeout: tServerTimeout,
    //         refreshRate: tRefreshRate,
    //         doubleTapToExit: tDoubleTapToExit,
    //         maskSensitiveInfo: tMaskSensitiveInfo,
    //         lastSelectedServer: tTautulliId,
    //         statsType: tStatsType,
    //       ),
    //     );
    //   });
    //   test(
    //     'should call the Settings.setLastAppVersion() use case',
    //     () async {
    //       // act
    //       bloc.add(SettingsUpdateLastAppVersion());
    //       await untilCalled(mockSettings.setLastAppVersion('2.0.0'));
    //       // assert
    //       verify(mockSettings.setLastAppVersion('2.0.0'));
    //     },
    //   );
    // });
  });
}
