// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/graphs/domain/repositories/graphs_repository.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_stream_resolution.dart';
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
  GetPlaysByStreamResolution usecase;
  MockGraphsRepository mockGraphsRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGraphsRepository = MockGraphsRepository();
    usecase = GetPlaysByStreamResolution(
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

  final playsByStreamResolutionJson =
      json.decode(fixture('graphs_play_by_stream_resolution.json'));
  final List<String> tPlaysByStreamResolutionCategories = List<String>.from(
    playsByStreamResolutionJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByStreamResolutionSeriesDataList = [];
  playsByStreamResolutionJson['response']['data']['series'].forEach((item) {
    tPlaysByStreamResolutionSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByStreamResolutionGraphData = GraphDataModel(
    categories: tPlaysByStreamResolutionCategories,
    seriesDataList: tPlaysByStreamResolutionSeriesDataList,
  );

  test(
    'should get GraphData from repository',
    () async {
      // arrange
      when(
        mockGraphsRepository.getPlaysByStreamResolution(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tPlaysByStreamResolutionGraphData));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tPlaysByStreamResolutionGraphData)));
    },
  );
}
