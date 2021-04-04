import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_statistic_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_statistic.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_user_stats.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_watch_time_stats.dart';
import 'package:tautulli_remote/features/libraries/presentation/bloc/library_statistics_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetLibraryWatchTimeStats extends Mock
    implements GetLibraryWatchTimeStats {}

class MockGetLibraryUserStats extends Mock implements GetLibraryUserStats {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  LibraryStatisticsBloc bloc;
  MockGetLibraryWatchTimeStats mockGetLibraryWatchTimeStats;
  MockGetLibraryUserStats mockGetLibraryUserStats;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetLibraryWatchTimeStats = MockGetLibraryWatchTimeStats();
    mockGetLibraryUserStats = MockGetLibraryUserStats();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
    bloc = LibraryStatisticsBloc(
      getLibraryUserStats: mockGetLibraryUserStats,
      getLibraryWatchTimeStats: mockGetLibraryWatchTimeStats,
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

  void setUpSuccess() {
    when(mockGetLibraryWatchTimeStats(
      tautulliId: anyNamed('tautulliId'),
      sectionId: anyNamed('sectionId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tLibraryWatchTimeStatsList));
    when(mockGetLibraryUserStats(
      tautulliId: anyNamed('tautulliId'),
      sectionId: anyNamed('sectionId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tLibraryUserStatsList));
  }

  test(
    'initialState should be LibraryStatisticsInitial',
    () async {
      // assert
      expect(bloc.state, LibraryStatisticsInitial());
    },
  );

  group('LibraryStatisticsFetch', () {
    test(
      'should get data from GetLibraryWatchTimeStats use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(LibraryStatisticsFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(mockGetLibraryWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
        // assert
        verify(
          mockGetLibraryWatchTimeStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should get data from GetLibraryUserStats use case',
      () async {
        // arrange
        clearCache();
        setUpSuccess();
        // act
        bloc.add(LibraryStatisticsFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(mockGetLibraryUserStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
        // assert
        verify(
          mockGetLibraryUserStats(
            tautulliId: tTautulliId,
            sectionId: tSectionId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [LibraryStatisticsSuccess] when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          LibraryStatisticsInProgress(),
          LibraryStatisticsSuccess(
            userStatsList: tLibraryUserStatsList,
            watchTimeStatsList: tLibraryWatchTimeStatsList,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibraryStatisticsFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [LibraryStatisticsSuccess] when getWatchTimeStats is fetched successfully but getUserStats fails',
      () async {
        // arrange
        clearCache();
        when(mockGetLibraryWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Right(tLibraryWatchTimeStatsList));
        when(mockGetLibraryUserStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        // assert later
        final expected = [
          LibraryStatisticsInProgress(),
          LibraryStatisticsSuccess(
            watchTimeStatsList: tLibraryWatchTimeStatsList,
            userStatsList: [],
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibraryStatisticsFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [LibraryStatisticsSuccess] when getUserStats is fetched successfully but getWatchTimeStats fails',
      () async {
        // arrange
        clearCache();
        when(mockGetLibraryWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        when(mockGetLibraryUserStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Right(tLibraryUserStatsList));
        // assert later
        final expected = [
          LibraryStatisticsInProgress(),
          LibraryStatisticsSuccess(
            watchTimeStatsList: [],
            userStatsList: tLibraryUserStatsList,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibraryStatisticsFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );

    test(
      'should emit [LibraryStatisticsFailure] when getWatchTimeStats and getUserStats fail',
      () async {
        // arrange
        clearCache();
        when(mockGetLibraryWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        when(mockGetLibraryUserStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => Left(TimeoutFailure()));
        // assert later
        final expected = [
          LibraryStatisticsInProgress(),
          LibraryStatisticsFailure(
            failure: TimeoutFailure(),
            message: TIMEOUT_FAILURE_MESSAGE,
            suggestion: PLEX_CONNECTION_SUGGESTION,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(LibraryStatisticsFetch(
          tautulliId: tTautulliId,
          sectionId: tSectionId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });
}
