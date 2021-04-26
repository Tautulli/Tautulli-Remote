import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/graphs/domain/repositories/graphs_repository.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_stream_type_by_top_10_users.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGraphsRepository extends Mock implements GraphsRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetStreamTypeByTop10Users usecase;
  MockGraphsRepository mockGraphsRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGraphsRepository = MockGraphsRepository();
    usecase = GetStreamTypeByTop10Users(
      repository: mockGraphsRepository,
    );
    mockSettings = MockSettings();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';

  final streamTypeByTop10UsersJson =
      json.decode(fixture('graphs_stream_type_by_top_10_users.json'));
  final List<String> tStreamTypeByTop10UsersCategories = List<String>.from(
    streamTypeByTop10UsersJson['response']['data']['categories'],
  );
  final List<SeriesData> tStreamTypeByTop10UsersSeriesDataList = [];
  streamTypeByTop10UsersJson['response']['data']['series'].forEach((item) {
    tStreamTypeByTop10UsersSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tStreamTypeByTop10UsersGraphData = GraphDataModel(
    categories: tStreamTypeByTop10UsersCategories,
    seriesDataList: tStreamTypeByTop10UsersSeriesDataList,
  );

  test(
    'should get GraphData from repository',
    () async {
      // arrange
      when(
        mockGraphsRepository.getStreamTypeByTop10Users(
          tautulliId: anyNamed('tautulliId'),
          timeRange: anyNamed('timeRange'),
          yAxis: anyNamed('yAxis'),
          userId: anyNamed('userId'),
          grouping: anyNamed('grouping'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tStreamTypeByTop10UsersGraphData));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tStreamTypeByTop10UsersGraphData)));
    },
  );
}
