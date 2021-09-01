// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/graphs/domain/repositories/graphs_repository.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_top_10_users.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGraphsRepository extends Mock implements GraphsRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetPlaysByTop10Users usecase;
  MockGraphsRepository mockGraphsRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGraphsRepository = MockGraphsRepository();
    usecase = GetPlaysByTop10Users(
      repository: mockGraphsRepository,
    );
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';

  final playsByTop10UsersJson =
      json.decode(fixture('graphs_play_by_top_10_users.json'));
  final List<String> tPlaysByTop10UsersCategories = List<String>.from(
    playsByTop10UsersJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByTop10UsersSeriesDataList = [];
  playsByTop10UsersJson['response']['data']['series'].forEach((item) {
    tPlaysByTop10UsersSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByTop10UsersGraphData = GraphDataModel(
    categories: tPlaysByTop10UsersCategories,
    seriesDataList: tPlaysByTop10UsersSeriesDataList,
  );

  test(
    'should get GraphData from repository',
    () async {
      // arrange
      when(
        mockGraphsRepository.getPlaysByTop10Users(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tPlaysByTop10UsersGraphData));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tPlaysByTop10UsersGraphData)));
    },
  );
}
