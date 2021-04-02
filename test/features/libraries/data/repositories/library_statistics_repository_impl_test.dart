import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/libraries/data/datasources/library_statistics_data_source.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_statistic_model.dart';
import 'package:tautulli_remote/features/libraries/data/repositories/library_statistics_repository_impl.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_statistic.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibraryStatisticsDataSource extends Mock
    implements LibraryStatisticsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibraryStatisticsRepositoryImpl repository;
  MockLibraryStatisticsDataSource mockLibraryStatisticsDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockLibraryStatisticsDataSource = MockLibraryStatisticsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = LibraryStatisticsRepositoryImpl(
      dataSource: mockLibraryStatisticsDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final int tSectionId = 123;

  final List<LibraryStatistic> tLibraryWatchTimeStatsList = [];
  final List<LibraryStatistic> tLibraryUserStatsList = [];

  final libraryWatchTimeStatsJson =
      json.decode(fixture('library_watch_time_stats.json'));
  final libraryUserStatsJson = json.decode(fixture('library_user_stats.json'));

  libraryWatchTimeStatsJson['response']['data'].forEach((item) {
    tLibraryWatchTimeStatsList.add(LibraryStatisticModel.fromJson(
      libraryStatisticType: LibraryStatisticType.watchTime,
      json: item,
    ));
  });
  libraryUserStatsJson['response']['data'].forEach((item) {
    tLibraryUserStatsList.add(LibraryStatisticModel.fromJson(
      libraryStatisticType: LibraryStatisticType.user,
      json: item,
    ));
  });

  group('getLibraryWatchTimeStats', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getLibraryWatchTimeStats(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
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
        'should call the data source getLibraryWatchTimeStats()',
        () async {
          // act
          await repository.getLibraryWatchTimeStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockLibraryStatisticsDataSource.getLibraryWatchTimeStats(
              tautulliId: tTautulliId,
              sectionId: tSectionId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of User when call to API is successful',
        () async {
          // arrange
          when(
            mockLibraryStatisticsDataSource.getLibraryWatchTimeStats(
              tautulliId: tTautulliId,
              sectionId: tSectionId,
              settingsBloc: settingsBloc,
            ),
          ).thenAnswer((_) async => tLibraryWatchTimeStatsList);
          // act
          final result = await repository.getLibraryWatchTimeStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tLibraryWatchTimeStatsList)));
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
          final result = await repository.getLibraryWatchTimeStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('getLibraryUserStats', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getLibraryUserStats(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
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
        'should call the data source getLibraryUserStats()',
        () async {
          // act
          await repository.getLibraryUserStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockLibraryStatisticsDataSource.getLibraryUserStats(
              tautulliId: tTautulliId,
              sectionId: tSectionId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of User when call to API is successful',
        () async {
          // arrange
          when(
            mockLibraryStatisticsDataSource.getLibraryUserStats(
              tautulliId: tTautulliId,
              sectionId: tSectionId,
              settingsBloc: settingsBloc,
            ),
          ).thenAnswer((_) async => tLibraryUserStatsList);
          // act
          final result = await repository.getLibraryUserStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tLibraryUserStatsList)));
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
          final result = await repository.getLibraryUserStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
