import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/libraries/data/models/library_statistic_model.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_statistic.dart';
import 'package:tautulli_remote/features/libraries/domain/repositories/library_statistics_repository.dart';
import 'package:tautulli_remote/features/libraries/domain/usecases/get_library_user_stats.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLibraryStatisticsRepository extends Mock
    implements LibraryStatisticsRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetLibraryUserStats usecase;
  MockLibraryStatisticsRepository mockLibraryStatisticsRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockLibraryStatisticsRepository = MockLibraryStatisticsRepository();
    usecase = GetLibraryUserStats(
      repository: mockLibraryStatisticsRepository,
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
  const int tSectionId = 123;

  final List<LibraryStatistic> tLibraryUserStatsList = [];

  final libraryUserStatsJson = json.decode(fixture('library_user_stats.json'));

  libraryUserStatsJson['response']['data'].forEach((item) {
    tLibraryUserStatsList.add(LibraryStatisticModel.fromJson(
      libraryStatisticType: LibraryStatisticType.user,
      json: item,
    ));
  });

  test(
    'should get LibraryUserStats list from repository',
    () async {
      // arrange
      when(
        mockLibraryStatisticsRepository.getLibraryUserStats(
          tautulliId: anyNamed('tautulliId'),
          sectionId: anyNamed('sectionId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tLibraryUserStatsList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        sectionId: tSectionId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tLibraryUserStatsList)));
    },
  );
}
