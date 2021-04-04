import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_statistic_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_statistic.dart';
import 'package:tautulli_remote/features/libraries/domain/repositories/library_statistics_repository.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_watch_time_stats.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibraryStatisticsRepository extends Mock
    implements LibraryStatisticsRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetLibraryWatchTimeStats usecase;
  MockLibraryStatisticsRepository mockLibraryStatisticsRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockLibraryStatisticsRepository = MockLibraryStatisticsRepository();
    usecase = GetLibraryWatchTimeStats(
      repository: mockLibraryStatisticsRepository,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const int tSectionId = 123;

  final List<LibraryStatistic> tLibraryWatchTimeStatsList = [];

  final libraryWatchTimeStatsJson =
      json.decode(fixture('library_watch_time_stats.json'));

  libraryWatchTimeStatsJson['response']['data'].forEach((item) {
    tLibraryWatchTimeStatsList.add(LibraryStatisticModel.fromJson(
      libraryStatisticType: LibraryStatisticType.watchTime,
      json: item,
    ));
  });

  test(
    'should get LibraryWatchTimeStats list from repository',
    () async {
      // arrange
      when(
        mockLibraryStatisticsRepository.getLibraryWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tLibraryWatchTimeStatsList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        sectionId: tSectionId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tLibraryWatchTimeStatsList)));
    },
  );
}
