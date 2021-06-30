import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockGetServerInfo extends Mock implements tautulli_api.GetServerInfo {}

class MockGetSettings extends Mock implements tautulli_api.GetSettings {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  SettingsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  MockGetServerInfo mockApiGetServerInfo;
  MockGetSettings mockApiGetSettings;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockApiGetServerInfo = MockGetServerInfo();
    mockApiGetSettings = MockGetSettings();
    dataSource = SettingsDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      apiGetServerInfo: mockApiGetServerInfo,
      apiGetSettings: mockApiGetSettings,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  final tautulliSettingsJson = json.decode(fixture('tautulli_settings.json'));
  final tautulliSettingsGeneral = TautulliSettingsGeneralModel.fromJson(
      tautulliSettingsJson['response']['data']['General']);
  final tTautulliSettingsMap = {
    'general': tautulliSettingsGeneral,
  };

  group('Plex Server Info', () {
    test(
      'should call [getServerInfo] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetServerInfo(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => plexServerInfoJson);
        // act
        await dataSource.getPlexServerInfo(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetServerInfo(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a PlexServerInfo item',
      () async {
        // arrange
        when(
          mockApiGetServerInfo(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => plexServerInfoJson);
        // act
        final result = await dataSource.getPlexServerInfo(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tPlexServerInfo));
      },
    );
  });

  group('Tautulli Settings', () {
    test(
      'should call [getSettings] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetSettings(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tautulliSettingsJson);
        // act
        await dataSource.getTautulliSettings(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetSettings(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a Map of TautulliSettings items',
      () async {
        // arrange
        when(
          mockApiGetSettings(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tautulliSettingsJson);
        // act
        final result = await dataSource.getTautulliSettings(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tTautulliSettingsMap));
      },
    );
  });

  group('Server Timeout', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_SERVER_TIMEOUT))
            .thenReturn(3);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        verify(mockSharedPreferences.getInt(SETTINGS_SERVER_TIMEOUT));
        expect(serverTimeout, equals(3));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_SERVER_TIMEOUT))
            .thenReturn(null);
        // act
        final serverTimeout = await dataSource.getServerTimeout();
        // assert
        expect(serverTimeout, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the server timeout',
      () async {
        // act
        await dataSource.setServerTimeout(3);
        // assert
        verify(mockSharedPreferences.setInt(SETTINGS_SERVER_TIMEOUT, 3));
      },
    );
  });

  group('Refresh Rate', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE)).thenReturn(3);
        // act
        final refreshRate = await dataSource.getRefreshRate();
        // assert
        verify(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE));
        expect(refreshRate, equals(3));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(SETTINGS_REFRESH_RATE))
            .thenReturn(null);
        // act
        final refreshRate = await dataSource.getRefreshRate();
        // assert
        expect(refreshRate, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the refresh rate',
      () async {
        // act
        await dataSource.setRefreshRate(3);
        // assert
        verify(mockSharedPreferences.setInt(SETTINGS_REFRESH_RATE, 3));
      },
    );
  });

  group('Double Tap To Exit', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(SETTINGS_DOUBLE_TAP_TO_EXIT),
        ).thenReturn(true);
        // act
        final doubleTapToExit = await dataSource.getDoubleTapToExit();
        // assert
        verify(mockSharedPreferences.getBool(SETTINGS_DOUBLE_TAP_TO_EXIT));
        expect(doubleTapToExit, equals(true));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(SETTINGS_DOUBLE_TAP_TO_EXIT),
        ).thenReturn(null);
        // act
        final doubleTapToExit = await dataSource.getDoubleTapToExit();
        // assert
        expect(doubleTapToExit, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the double tap to exit value',
      () async {
        // act
        await dataSource.setDoubleTapToExit(true);
        // assert
        verify(
          mockSharedPreferences.setBool(SETTINGS_DOUBLE_TAP_TO_EXIT, true),
        );
      },
    );
  });

  group('Mask Sensitive Info', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(SETTINGS_MASK_SENSITIVE_INFO),
        ).thenReturn(true);
        // act
        final maskSensitiveInfo = await dataSource.getMaskSensitiveInfo();
        // assert
        verify(mockSharedPreferences.getBool(SETTINGS_MASK_SENSITIVE_INFO));
        expect(maskSensitiveInfo, equals(true));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(SETTINGS_MASK_SENSITIVE_INFO),
        ).thenReturn(null);
        // act
        final maskSensitiveInfo = await dataSource.getMaskSensitiveInfo();
        // assert
        expect(maskSensitiveInfo, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the mask sensitive info value',
      () async {
        // act
        await dataSource.setMaskSensitiveInfo(true);
        // assert
        verify(
          mockSharedPreferences.setBool(SETTINGS_MASK_SENSITIVE_INFO, true),
        );
      },
    );
  });

  group('Last Selected Server', () {
    test(
      'should return String from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getString(LAST_SELECTED_SERVER))
            .thenReturn('jkl');
        // act
        final lastSelectedServer = await dataSource.getLastSelectedServer();
        // assert
        verify(mockSharedPreferences.getString(LAST_SELECTED_SERVER));
        expect(lastSelectedServer, equals('jkl'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(LAST_SELECTED_SERVER))
            .thenReturn(null);
        // act
        final lastSelectedServer = await dataSource.getLastSelectedServer();
        // assert
        expect(lastSelectedServer, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the last selected server',
      () async {
        // act
        await dataSource.setLastSelectedServer('jkl');
        // assert
        verify(mockSharedPreferences.setString(LAST_SELECTED_SERVER, 'jkl'));
      },
    );
  });

  group('Stats Type', () {
    test(
      'should return String from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getString(STATS_TYPE))
            .thenReturn('duration');
        // act
        final statsType = await dataSource.getStatsType();
        // assert
        verify(mockSharedPreferences.getString(STATS_TYPE));
        expect(statsType, equals('duration'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(STATS_TYPE)).thenReturn(null);
        // act
        final statsType = await dataSource.getStatsType();
        // assert
        expect(statsType, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the stats type',
      () async {
        // act
        await dataSource.setStatsType('duration');
        // assert
        verify(mockSharedPreferences.setString(STATS_TYPE, 'duration'));
      },
    );
  });

  group('Y Axis', () {
    test(
      'should return String from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getString(Y_AXIS)).thenReturn('duration');
        // act
        final yAxis = await dataSource.getYAxis();
        // assert
        verify(mockSharedPreferences.getString(Y_AXIS));
        expect(yAxis, equals('duration'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(Y_AXIS)).thenReturn(null);
        // act
        final yAxis = await dataSource.getYAxis();
        // assert
        expect(yAxis, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the stats type',
      () async {
        // act
        await dataSource.setYAxis('duration');
        // assert
        verify(mockSharedPreferences.setString(Y_AXIS, 'duration'));
      },
    );
  });

  group('Users Sort', () {
    test(
      'should return String from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getString(USERS_SORT))
            .thenReturn('friendly_name|asc');
        // act
        final usersSort = await dataSource.getUsersSort();
        // assert
        verify(mockSharedPreferences.getString(USERS_SORT));
        expect(usersSort, equals('friendly_name|asc'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(USERS_SORT)).thenReturn(null);
        // act
        final usersSort = await dataSource.getUsersSort();
        // assert
        expect(usersSort, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the users sort',
      () async {
        // act
        await dataSource.setUsersSort('friendly_name|asc');
        // assert
        verify(
          mockSharedPreferences.setString(USERS_SORT, 'friendly_name|asc'),
        );
      },
    );
  });

  group('OneSignal Banner Dismissed', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(ONE_SIGNAL_BANNER_DISMISSED),
        ).thenReturn(true);
        // act
        final oneSignalBannerDismissed =
            await dataSource.getOneSignalBannerDismissed();
        // assert
        verify(mockSharedPreferences.getBool(ONE_SIGNAL_BANNER_DISMISSED));
        expect(oneSignalBannerDismissed, equals(true));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(ONE_SIGNAL_BANNER_DISMISSED),
        ).thenReturn(null);
        // act
        final oneSignalBannerDismissed =
            await dataSource.getOneSignalBannerDismissed();
        // assert
        expect(oneSignalBannerDismissed, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the banner dismissed value',
      () async {
        // act
        await dataSource.setOneSignalBannerDismissed(true);
        // assert
        verify(
          mockSharedPreferences.setBool(ONE_SIGNAL_BANNER_DISMISSED, true),
        );
      },
    );
  });

  group('OneSignal Consent', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(ONE_SIGNAL_CONSENTED),
        ).thenReturn(true);
        // act
        final oneSignalConsented = await dataSource.getOneSignalConsented();
        // assert
        verify(mockSharedPreferences.getBool(ONE_SIGNAL_CONSENTED));
        expect(oneSignalConsented, equals(true));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(ONE_SIGNAL_CONSENTED),
        ).thenReturn(null);
        // act
        final oneSignalConsented = await dataSource.getOneSignalConsented();
        // assert
        expect(oneSignalConsented, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the banner dismissed value',
      () async {
        // act
        await dataSource.setOneSignalConsented(true);
        // assert
        verify(
          mockSharedPreferences.setBool(ONE_SIGNAL_CONSENTED, true),
        );
      },
    );
  });

  group('Last app version', () {
    test(
      'should return String from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getString(LAST_APP_VERSION))
            .thenReturn('2.1.5');
        // act
        final lastAppVersion = await dataSource.getLastAppVersion();
        // assert
        verify(mockSharedPreferences.getString(LAST_APP_VERSION));
        expect(lastAppVersion, equals('2.1.5'));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(LAST_APP_VERSION))
            .thenReturn(null);
        // act
        final lastAppVersion = await dataSource.getLastAppVersion();
        // assert
        expect(lastAppVersion, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the last app version',
      () async {
        // act
        await dataSource.setLastAppVersion('2.1.5');
        // assert
        verify(mockSharedPreferences.setString(LAST_APP_VERSION, '2.1.5'));
      },
    );
  });

  group('Read Announcement Count', () {
    test(
      'should return int from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(LAST_READ_ANNOUNCEMENT_ID))
            .thenReturn(1);
        // act
        final readAnnouncementCount =
            await dataSource.getLastReadAnnouncementId();
        // assert
        verify(mockSharedPreferences.getInt(LAST_READ_ANNOUNCEMENT_ID));
        expect(readAnnouncementCount, equals(1));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getInt(LAST_READ_ANNOUNCEMENT_ID))
            .thenReturn(null);
        // act
        final readAnnouncementCount =
            await dataSource.getLastReadAnnouncementId();
        // assert
        expect(readAnnouncementCount, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the refresh rate',
      () async {
        // act
        await dataSource.setLastReadAnnouncementId(1);
        // assert
        verify(mockSharedPreferences.setInt(LAST_READ_ANNOUNCEMENT_ID, 1));
      },
    );
  });

  group('Wizard Complete Status', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(WIZARD_COMPLETE_STATUS),
        ).thenReturn(true);
        // act
        final wizardCompleteStauts = await dataSource.getWizardCompleteStatus();
        // assert
        verify(mockSharedPreferences.getBool(WIZARD_COMPLETE_STATUS));
        expect(wizardCompleteStauts, equals(true));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(WIZARD_COMPLETE_STATUS),
        ).thenReturn(null);
        // act
        final wizardCompleteStauts = await dataSource.getWizardCompleteStatus();
        // assert
        expect(wizardCompleteStauts, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the wizard complete status value',
      () async {
        // act
        await dataSource.setWizardCompleteStatus(true);
        // assert
        verify(
          mockSharedPreferences.setBool(WIZARD_COMPLETE_STATUS, true),
        );
      },
    );
  });

  group('Custom Cert Hash List', () {
    test(
      'should return list of custom cert hashes from settings',
      () async {
        // arrange
        when(mockSharedPreferences.getStringList(CUSTOM_CERT_HASH_LIST))
            .thenReturn(['1', '2']);
        // act
        final customCertHashList = await dataSource.getCustomCertHashList();
        // assert
        verify(mockSharedPreferences.getStringList(CUSTOM_CERT_HASH_LIST));
        expect(customCertHashList, equals([1, 2]));
      },
    );

    test(
      'should return empty list when there is no stored value',
      () async {
        // arrange
        when(mockSharedPreferences.getStringList(CUSTOM_CERT_HASH_LIST))
            .thenReturn([]);
        // act
        final customCertHashList = await dataSource.getCustomCertHashList();
        // assert
        expect(customCertHashList, equals([]));
      },
    );

    test(
      'should call SharedPreferences to save the custom cert hash list',
      () async {
        // act
        await dataSource.setCustomCertHashList([1, 2]);
        // assert
        verify(
          mockSharedPreferences
              .setStringList(CUSTOM_CERT_HASH_LIST, ['1', '2']),
        );
      },
    );
  });

  group('iOS Local Notification Permission Prompt', () {
    test(
      'should return bool from settings',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(IOS_LOCAL_NETWORK_PERMISSION_PROMPTED),
        ).thenReturn(true);
        // act
        final iosLocalNetworkPermissionPrompted =
            await dataSource.getIosLocalNetworkPermissionPrompted();
        // assert
        verify(mockSharedPreferences
            .getBool(IOS_LOCAL_NETWORK_PERMISSION_PROMPTED));
        expect(iosLocalNetworkPermissionPrompted, equals(true));
      },
    );

    test(
      'should return null when there is no stored value',
      () async {
        // arrange
        when(
          mockSharedPreferences.getBool(IOS_LOCAL_NETWORK_PERMISSION_PROMPTED),
        ).thenReturn(null);
        // act
        final iosLocalNetworkPermissionPrompted =
            await dataSource.getIosLocalNetworkPermissionPrompted();
        // assert
        expect(iosLocalNetworkPermissionPrompted, equals(null));
      },
    );

    test(
      'should call SharedPreferences to save the wizard complete status value',
      () async {
        // act
        await dataSource.setIosLocalNetworkPermissionPrompted(true);
        // assert
        verify(
          mockSharedPreferences.setBool(
              IOS_LOCAL_NETWORK_PERMISSION_PROMPTED, true),
        );
      },
    );
  });
}
