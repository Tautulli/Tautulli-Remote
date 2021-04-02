import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/libraries/data/datasources/library_statistics_data_source.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_statistic_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_statistic.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibraryWatchTimeStats extends Mock
    implements tautulliApi.GetLibraryWatchTimeStats {}

class MockGetLibraryUserStats extends Mock
    implements tautulliApi.GetLibraryUserStats {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibraryStatisticsDataSourceImpl dataSource;
  MockGetLibraryWatchTimeStats mockApiGetLibraryWatchTimeStats;
  MockGetLibraryUserStats mockApiGetLibraryUserStats;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetLibraryWatchTimeStats = MockGetLibraryWatchTimeStats();
    mockApiGetLibraryUserStats = MockGetLibraryUserStats();
    dataSource = LibraryStatisticsDataSourceImpl(
      apiGetLibraryUserStats: mockApiGetLibraryUserStats,
      apiGetLibraryWatchTimeStats: mockApiGetLibraryWatchTimeStats,
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
      'should call [getLibraryWatchTimeStats] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetLibraryWatchTimeStats(
            tautulliId: anyNamed('tautulliId'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => libraryWatchTimeStatsJson);
        // act
        await dataSource.getLibraryWatchTimeStats(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetLibraryWatchTimeStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of LibraryStatistic',
      () async {
        // arrange
        when(
          mockApiGetLibraryWatchTimeStats(
            tautulliId: anyNamed('tautulliId'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => libraryWatchTimeStatsJson);
        // act
        final result = await dataSource.getLibraryWatchTimeStats(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tLibraryWatchTimeStatsList));
      },
    );
  });

  group('getLibraryUserStats', () {
    test(
      'should call [getLibraryUserStats] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetLibraryUserStats(
            tautulliId: anyNamed('tautulliId'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => libraryUserStatsJson);
        // act
        await dataSource.getLibraryUserStats(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetLibraryUserStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of LibraryStatistic',
      () async {
        // arrange
        when(
          mockApiGetLibraryUserStats(
            tautulliId: anyNamed('tautulliId'),
            sectionId: anyNamed('sectionId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => libraryUserStatsJson);
        // act
        final result = await dataSource.getLibraryUserStats(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tLibraryUserStatsList));
      },
    );
  });
}
