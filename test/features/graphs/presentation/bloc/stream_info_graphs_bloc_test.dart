import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/graphs/data/models/graph_data_model.dart';
import 'package:tautulli_remote/features/graphs/data/models/series_data_model.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/graph_state.dart';
import 'package:tautulli_remote/features/graphs/domain/entities/series_data.dart';
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_by_stream_type.dart';
import 'package:tautulli_remote/features/graphs/presentation/bloc/stream_info_graphs_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPlaysByStreamType extends Mock implements GetPlaysByStreamType {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  StreamInfoGraphsBloc bloc;
  MockGetPlaysByStreamType mockGetPlaysByStreamType;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetPlaysByStreamType = MockGetPlaysByStreamType();
    mockLogging = MockLogging();
    bloc = StreamInfoGraphsBloc(
      getPlaysByStreamType: mockGetPlaysByStreamType,
      logging: mockLogging,
    );
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const String tYAxis = 'duration';

  final playsByStreamTypeJson =
      json.decode(fixture('graphs_play_by_stream_type.json'));
  final List<String> tPlaysByStreamTypeCategories = List<String>.from(
    playsByStreamTypeJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysByStreamTypeSeriesDataList = [];
  playsByStreamTypeJson['response']['data']['series'].forEach((item) {
    tPlaysByStreamTypeSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysByStreamTypeGraphData = GraphDataModel(
    categories: tPlaysByStreamTypeCategories,
    seriesDataList: tPlaysByStreamTypeSeriesDataList,
  );

  void setUpSuccess() {
    when(mockGetPlaysByStreamType(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysByStreamTypeGraphData));
  }

  StreamInfoGraphsLoaded loadingState() {
    final playsByStreamTypeGraphState = GraphState(
      graphData: null,
      yAxis: tYAxis,
      graphCurrentState: GraphCurrentState.inProgress,
      graphType: GraphType.playsByStreamType,
    );
    final currentState = StreamInfoGraphsLoaded(
      playsByStreamType: playsByStreamTypeGraphState,
    );

    return currentState;
  }

  test(
    'initialState should be StreamInfoGraphsInitial',
    () async {
      // assert
      expect(bloc.state, StreamInfoGraphsInitial());
    },
  );

  group('StreamInfoGraphsFetch', () {
    test(
      'should get data from GetPlaysByStreamType use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          StreamInfoGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysByStreamType(
            tautulliId: anyNamed('tautulliId'),
            timeRange: anyNamed('timeRange'),
            yAxis: anyNamed('yAxis'),
            userId: anyNamed('userId'),
            grouping: anyNamed('grouping'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(
          mockGetPlaysByStreamType(
            tautulliId: anyNamed('tautulliId'),
            timeRange: anyNamed('timeRange'),
            yAxis: anyNamed('yAxis'),
            userId: anyNamed('userId'),
            grouping: anyNamed('grouping'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
      },
    );
  });

  group('StreamInfoGraphsLoadPlaysByDate', () {
    test(
      'should emit [StreamInfoGraphLoaded] with playsByStreamType graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByStreamType: GraphState(
              graphData: tPlaysByStreamTypeGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsByStreamType,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          StreamInfoGraphsLoadPlaysByStreamType(
            tautulliId: tTautulliId,
            failureOrPlaysByStreamType: Right(tPlaysByStreamTypeGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [StreamInfoGraphLoaded] with playsByStreamType graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsByStreamType: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsByStreamType,
              failureMessage: FailureMapperHelper.mapFailureToMessage(failure),
              failureSuggestion:
                  FailureMapperHelper.mapFailureToSuggestion(failure),
              failure: failure,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          StreamInfoGraphsLoadPlaysByStreamType(
            tautulliId: tTautulliId,
            failureOrPlaysByStreamType: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });
}
