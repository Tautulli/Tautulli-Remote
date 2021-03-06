import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/models/user_statistic_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_statistic.dart';
import 'package:tautulli_remote/features/users/domain/repositories/user_statistics_repository.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user_watch_time_stats.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUserStatisticsRepository extends Mock
    implements UserStatisticsRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetUserWatchTimeStats usecase;
  MockUserStatisticsRepository mockUserStatisticsRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockUserStatisticsRepository = MockUserStatisticsRepository();
    usecase = GetUserWatchTimeStats(
      repository: mockUserStatisticsRepository,
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

  const tTautulliId = 'jkl';
  const tUserId = 123;

  final List<UserStatistic> tUserWatchTimeStatsList = [];

  final userWatchTimeStatsJson =
      json.decode(fixture('user_watch_time_stats.json'));

  userWatchTimeStatsJson['response']['data'].forEach((item) {
    tUserWatchTimeStatsList.add(UserStatisticModel.fromJson(
      userStatisticType: UserStatisticType.watchTime,
      json: item,
    ));
  });

  test(
    'should get UserWatchTimeStats list from repository',
    () async {
      // arrange
      when(
        mockUserStatisticsRepository.getUserWatchTimeStats(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tUserWatchTimeStatsList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        userId: tUserId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tUserWatchTimeStatsList)));
    },
  );
}
