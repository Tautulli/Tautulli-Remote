import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/settings/data/datasources/settings_data_source.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSettingsDataSource extends Mock implements SettingsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  SettingsRepositoryImpl repository;
  MockSettingsDataSource mockSettingsDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockSettingsDataSource = MockSettingsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SettingsRepositoryImpl(
      dataSource: mockSettingsDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final int tServerTimeout = 3;
  final int tRefreshRate = 5;
  final bool tMaskSensitiveInfo = true;
  final String tTautulliId = 'jkl';
  final String tStatsType = 'duration';
  final String tLastAppVersion = '2.1.5';
  final int tLastReadAnnouncementId = 1;
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
        repository.getPlexServerInfo(tTautulliId);
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
          await repository.getPlexServerInfo(tTautulliId);
          // assert
          verify(
            mockSettingsDataSource.getPlexServerInfo(tTautulliId),
          );
        },
      );

      test(
        'should return MetadataItem when call to API is successful',
        () async {
          // arrange
          when(
            mockSettingsDataSource.getPlexServerInfo(any),
          ).thenAnswer((_) async => tPlexServerInfo);
          // act
          final result = await repository.getPlexServerInfo(tTautulliId);
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
          final result = await repository.getPlexServerInfo(tTautulliId);
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
        repository.getPlexServerInfo(tTautulliId);
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
          await repository.getTautulliSettings(tTautulliId);
          // assert
          verify(
            mockSettingsDataSource.getTautulliSettings(tTautulliId),
          );
        },
      );

      test(
        'should return MetadataItem when call to API is successful',
        () async {
          // arrange
          when(
            mockSettingsDataSource.getTautulliSettings(any),
          ).thenAnswer((_) async => tTautulliSettingsMap);
          // act
          final result = await repository.getTautulliSettings(tTautulliId);
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
          final result = await repository.getPlexServerInfo(tTautulliId);
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
        await repository.setStatsType(tLastAppVersion);
        // assert
        verify(mockSettingsDataSource.setStatsType(tLastAppVersion));
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
}
