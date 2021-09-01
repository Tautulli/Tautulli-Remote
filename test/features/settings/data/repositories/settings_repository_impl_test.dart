// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettingsDataSource extends Mock implements SettingsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockOneSignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  SettingsRepositoryImpl repository;
  MockSettingsDataSource mockSettingsDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockOneSignal mockOneSignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockSettingsDataSource = MockSettingsDataSource();
    mockOneSignal = MockOneSignal();
    mockRegisterDevice = MockRegisterDevice();
    mockNetworkInfo = MockNetworkInfo();
    repository = SettingsRepositoryImpl(
      dataSource: mockSettingsDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOneSignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const int tServerTimeout = 3;
  const int tRefreshRate = 5;
  const bool tDoubleTapToExit = true;
  const bool tMaskSensitiveInfo = true;
  const String tTautulliId = 'jkl';
  const String tStatsType = 'duration';
  const String tYAxis = 'duration';
  const String tUsersSort = 'friendly_name|asc';
  const bool tOneSignalBannerDismissed = false;
  const bool tOneSignalConsented = false;
  const String tLastAppVersion = '2.1.5';
  const int tLastReadAnnouncementId = 1;
  const bool tWizardCompleteStatus = false;
  const bool tIosLocalNetworkPermissionPrompt = false;
  const bool tGraphTipsShown = false;
  final List<int> tCustomCertHashList = [1, 2];

  final plexServerInfoJson = json.decode(fixture('plex_server_info.json'));
  final PlexServerInfo tPlexServerInfo =
      PlexServerInfoModel.fromJson(plexServerInfoJson['response']['data']);

  final tautulliSettingsJson = json.decode(fixture('tautulli_settings.json'));
  final tautulliSettingsGeneral = TautulliSettingsGeneralModel.fromJson(
      tautulliSettingsJson['response']['data']['General']);
  final tTautulliSettingsMap = {
    'general': tautulliSettingsGeneral,
  };

  group('getPlexServerInfo', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlexServerInfo(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getPlexServerInfo()',
        () async {
          // act
          await repository.getPlexServerInfo(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockSettingsDataSource.getPlexServerInfo(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return MetadataItem when call to API is successful',
        () async {
          // arrange
          when(
            mockSettingsDataSource.getPlexServerInfo(
              tautulliId: anyNamed('tautulliId'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tPlexServerInfo);
          // act
          final result = await repository.getPlexServerInfo(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tPlexServerInfo)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getPlexServerInfo(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('getTautulliSettings', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getPlexServerInfo(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getTautulliSettings()',
        () async {
          // act
          await repository.getTautulliSettings(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockSettingsDataSource.getTautulliSettings(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return MetadataItem when call to API is successful',
        () async {
          // arrange
          when(
            mockSettingsDataSource.getTautulliSettings(
              tautulliId: anyNamed('tautulliId'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tTautulliSettingsMap);
          // act
          final result = await repository.getTautulliSettings(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tTautulliSettingsMap)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getPlexServerInfo(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('Server Timeout', () {
    test(
      'should return the server timeout from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getServerTimeout())
            .thenAnswer((_) async => tServerTimeout);
        // act
        final result = await repository.getServerTimeout();
        // assert
        expect(result, equals(tServerTimeout));
      },
    );

    test(
      'should forward the call to the data source to set server timeout',
      () async {
        // act
        await repository.setServerTimeout(tServerTimeout);
        // assert
        verify(mockSettingsDataSource.setServerTimeout(tServerTimeout));
      },
    );
  });

  group('Refresh Rate', () {
    test(
      'should return the refresh rate from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getRefreshRate())
            .thenAnswer((_) async => tRefreshRate);
        // act
        final result = await repository.getRefreshRate();
        // assert
        expect(result, equals(tRefreshRate));
      },
    );

    test(
      'should forward the call to the data source to set refresh rate',
      () async {
        // act
        await repository.setRefreshRate(tRefreshRate);
        // assert
        verify(mockSettingsDataSource.setRefreshRate(tRefreshRate));
      },
    );
  });

  group('Double Tap To Exit', () {
    test(
      'should return the double tap to exit value from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getDoubleTapToExit())
            .thenAnswer((_) async => tDoubleTapToExit);
        // act
        final result = await repository.getDoubleTapToExit();
        // assert
        expect(result, equals(tDoubleTapToExit));
      },
    );

    test(
      'should forward the call to the data source to set double tap to exit',
      () async {
        // act
        await repository.setDoubleTapToExit(tDoubleTapToExit);
        // assert
        verify(mockSettingsDataSource.setDoubleTapToExit(tDoubleTapToExit));
      },
    );
  });

  group('Mask Sensitive Info', () {
    test(
      'should return the mask sensitive info value from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getMaskSensitiveInfo())
            .thenAnswer((_) async => tMaskSensitiveInfo);
        // act
        final result = await repository.getMaskSensitiveInfo();
        // assert
        expect(result, equals(tMaskSensitiveInfo));
      },
    );

    test(
      'should forward the call to the data source to set mask sensitive info',
      () async {
        // act
        await repository.setMaskSensitiveInfo(tMaskSensitiveInfo);
        // assert
        verify(mockSettingsDataSource.setMaskSensitiveInfo(tMaskSensitiveInfo));
      },
    );
  });

  group('Last Selected Server', () {
    test(
      'should return the last selected server from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getLastSelectedServer())
            .thenAnswer((_) async => tTautulliId);
        // act
        final result = await repository.getLastSelectedServer();
        // assert
        expect(result, equals(tTautulliId));
      },
    );

    test(
      'should forward the call to the data source to set last selected server',
      () async {
        // act
        await repository.setLastSelectedServer(tTautulliId);
        // assert
        verify(mockSettingsDataSource.setLastSelectedServer(tTautulliId));
      },
    );
  });

  group('Stats Type', () {
    test(
      'should return the stats type from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getStatsType())
            .thenAnswer((_) async => tStatsType);
        // act
        final result = await repository.getStatsType();
        // assert
        expect(result, equals(tStatsType));
      },
    );

    test(
      'should forward the call to the data source to set stats type',
      () async {
        // act
        await repository.setStatsType(tStatsType);
        // assert
        verify(mockSettingsDataSource.setStatsType(tStatsType));
      },
    );
  });

  group('Y Axis', () {
    test(
      'should return the y axis from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getYAxis()).thenAnswer((_) async => tYAxis);
        // act
        final result = await repository.getYAxis();
        // assert
        expect(result, equals(tYAxis));
      },
    );

    test(
      'should forward the call to the data source to set stats type',
      () async {
        // act
        await repository.setYAxis(tYAxis);
        // assert
        verify(mockSettingsDataSource.setYAxis(tYAxis));
      },
    );
  });

  group('Users Sort', () {
    test(
      'should return the users sort from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getUsersSort())
            .thenAnswer((_) async => tUsersSort);
        // act
        final result = await repository.getUsersSort();
        // assert
        expect(result, equals(tUsersSort));
      },
    );

    test(
      'should forward the call to the data source to set stats type',
      () async {
        // act
        await repository.setUsersSort(tUsersSort);
        // assert
        verify(mockSettingsDataSource.setUsersSort(tUsersSort));
      },
    );
  });

  group('OneSignal Banner Dismissed', () {
    test(
      'should return the banner dismiss value from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getOneSignalBannerDismissed())
            .thenAnswer((_) async => tOneSignalBannerDismissed);
        // act
        final result = await repository.getOneSignalBannerDismissed();
        // assert
        expect(result, equals(tOneSignalBannerDismissed));
      },
    );

    test(
      'should forward the call to the data source to set banner dismiss',
      () async {
        // act
        await repository.setOneSignalBannerDismissed(tOneSignalBannerDismissed);
        // assert
        verify(mockSettingsDataSource
            .setOneSignalBannerDismissed(tOneSignalBannerDismissed));
      },
    );
  });

  group('OneSignal Consent', () {
    test(
      'should return the OneSignal consent value from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getOneSignalConsented())
            .thenAnswer((_) async => tOneSignalConsented);
        // act
        final result = await repository.getOneSignalConsented();
        // assert
        expect(result, equals(tOneSignalConsented));
      },
    );

    test(
      'should forward the call to the data source to set banner dismiss',
      () async {
        // act
        await repository.setOneSignalConsented(tOneSignalConsented);
        // assert
        verify(
            mockSettingsDataSource.setOneSignalConsented(tOneSignalConsented));
      },
    );
  });

  group('Last app version', () {
    test(
      'should return the last app version from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getLastAppVersion())
            .thenAnswer((_) async => tLastAppVersion);
        // act
        final result = await repository.getLastAppVersion();
        // assert
        expect(result, equals(tLastAppVersion));
      },
    );

    test(
      'should forward the call to the data source to set last app version',
      () async {
        // act
        await repository.setLastAppVersion(tLastAppVersion);
        // assert
        verify(mockSettingsDataSource.setLastAppVersion(tLastAppVersion));
      },
    );
  });

  group('Read Announcement Count', () {
    test(
      'should return the read announcement ID from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getLastReadAnnouncementId())
            .thenAnswer((_) async => tLastReadAnnouncementId);
        // act
        final result = await repository.getLastReadAnnouncementId();
        // assert
        expect(result, equals(tLastReadAnnouncementId));
      },
    );

    test(
      'should forward the call to the data source to set read announcement ID',
      () async {
        // act
        await repository.setLastReadAnnouncementId(tLastReadAnnouncementId);
        // assert
        verify(mockSettingsDataSource
            .setLastReadAnnouncementId(tLastReadAnnouncementId));
      },
    );
  });

  group('Wizard Complete Status', () {
    test(
      'should return the wizard complete status value from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getWizardCompleteStatus())
            .thenAnswer((_) async => tWizardCompleteStatus);
        // act
        final result = await repository.getWizardCompleteStatus();
        // assert
        expect(result, equals(tWizardCompleteStatus));
      },
    );

    test(
      'should forward the call to the data source to set banner dismiss',
      () async {
        // act
        await repository.setWizardCompleteStatus(tWizardCompleteStatus);
        // assert
        verify(mockSettingsDataSource
            .setWizardCompleteStatus(tWizardCompleteStatus));
      },
    );
  });

  group('Custom Cert Hash List', () {
    test(
      'should return the list of custom cert hashes from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getCustomCertHashList())
            .thenAnswer((_) async => tCustomCertHashList);
        // act
        final result = await repository.getCustomCertHashList();
        // assert
        expect(result, equals(tCustomCertHashList));
      },
    );

    test(
      'should forward the call to the data source to set custom cert hash list',
      () async {
        // act
        await repository.setCustomCertHashList(tCustomCertHashList);
        // assert
        verify(
            mockSettingsDataSource.setCustomCertHashList(tCustomCertHashList));
      },
    );
  });

  group('iOS Local Network Permission Prompt', () {
    test(
      'should return the local network permission prompt value from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getIosLocalNetworkPermissionPrompted())
            .thenAnswer((_) async => tIosLocalNetworkPermissionPrompt);
        // act
        final result = await repository.getIosLocalNetworkPermissionPrompted();
        // assert
        expect(result, equals(tIosLocalNetworkPermissionPrompt));
      },
    );

    test(
      'should forward the call to the data source to set local network permission prompted',
      () async {
        // act
        await repository.setIosLocalNetworkPermissionPrompted(
            tIosLocalNetworkPermissionPrompt);
        // assert
        verify(mockSettingsDataSource.setIosLocalNetworkPermissionPrompted(
            tIosLocalNetworkPermissionPrompt));
      },
    );
  });

  group('Graph Tips Shown', () {
    test(
      'should return the graph tips shown value from settings',
      () async {
        // arrange
        when(mockSettingsDataSource.getGraphTipsShown())
            .thenAnswer((_) async => tGraphTipsShown);
        // act
        final result = await repository.getGraphTipsShown();
        // assert
        expect(result, equals(tGraphTipsShown));
      },
    );

    test(
      'should forward the call to the data source to set graph tips shown',
      () async {
        // act
        await repository.setGraphTipsShown(tGraphTipsShown);
        // assert
        verify(mockSettingsDataSource.setGraphTipsShown(tGraphTipsShown));
      },
    );
  });
}
