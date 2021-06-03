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
import 'package:tautulli_remote/features/graphs/domain/usecases/get_plays_per_month.dart';
import 'package:tautulli_remote/features/graphs/presentation/bloc/play_totals_graphs_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPlaysPerMonth extends Mock implements GetPlaysPerMonth {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  PlayTotalsGraphsBloc bloc;
  MockGetPlaysPerMonth mockGetPlaysPerMonth;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetPlaysPerMonth = MockGetPlaysPerMonth();
    mockLogging = MockLogging();
    bloc = PlayTotalsGraphsBloc(
      getPlaysPerMonth: mockGetPlaysPerMonth,
      logging: mockLogging,
    );
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
  const String tYAxis = 'duration';

  final playsPerMonthJson = json.decode(fixture('graphs_play_per_month.json'));
  final List<String> tPlaysPerMonthCategories = List<String>.from(
    playsPerMonthJson['response']['data']['categories'],
  );
  final List<SeriesData> tPlaysPerMonthSeriesDataList = [];
  playsPerMonthJson['response']['data']['series'].forEach((item) {
    tPlaysPerMonthSeriesDataList.add(SeriesDataModel.fromJson(item));
  });
  final tPlaysPerMonthGraphData = GraphDataModel(
    categories: tPlaysPerMonthCategories,
    seriesDataList: tPlaysPerMonthSeriesDataList,
  );

  void setUpSuccess() {
    when(mockGetPlaysPerMonth(
      tautulliId: anyNamed('tautulliId'),
      timeRange: anyNamed('timeRange'),
      yAxis: anyNamed('yAxis'),
      userId: anyNamed('userId'),
      grouping: anyNamed('grouping'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tPlaysPerMonthGraphData));
  }

  PlayTotalsGraphsLoaded loadingState() {
    final playsPerMonthGraphState = GraphState(
        graphData: null,
        yAxis: tYAxis,
        graphCurrentState: GraphCurrentState.inProgress,
        graphType: GraphType.playsPerMonth);
    final currentState = PlayTotalsGraphsLoaded(
      playsPerMonth: playsPerMonthGraphState,
    );

    return currentState;
  }

  test(
    'initialState should be PlayTotalsGraphsInitial',
    () async {
      // assert
      expect(bloc.state, PlayTotalsGraphsInitial());
    },
  );

  group('PlayTotalsGraphsFetch', () {
    test(
      'should get data from GetPlaysPerMonth use case',
      () async {
        // arrange
        setUpSuccess();
        // act
        bloc.add(
          PlayTotalsGraphsFetch(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
        await untilCalled(
          mockGetPlaysPerMonth(
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
          mockGetPlaysPerMonth(
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

  group('PlayTotalsGraphsLoadPlaysPerMonth', () {
    test(
      'should emit [PlayTotalsGraphLoaded] with playsPerMonth graphCurrentState as success when graph data is fetched successfully',
      () async {
        // arrange
        final currentState = loadingState();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsPerMonth: GraphState(
              graphData: tPlaysPerMonthGraphData,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.success,
              graphType: GraphType.playsPerMonth,
            ),
          )
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          PlayTotalsGraphsLoadPlaysPerMonth(
            tautulliId: tTautulliId,
            failureOrPlaysPerMonth: Right(tPlaysPerMonthGraphData),
            yAxis: tYAxis,
          ),
        );
      },
    );

    test(
      'should emit [PlayTotalsGraphLoaded] with playsPerMonth graphCurrentState as failure when fetching graph data fails',
      () async {
        // arrange
        final currentState = loadingState();
        final failure = ServerFailure();
        bloc.emit(currentState);
        // assert later
        final expected = [
          currentState.copyWith(
            playsPerMonth: GraphState(
              graphData: null,
              yAxis: tYAxis,
              graphCurrentState: GraphCurrentState.failure,
              graphType: GraphType.playsPerMonth,
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
          PlayTotalsGraphsLoadPlaysPerMonth(
            tautulliId: tTautulliId,
            failureOrPlaysPerMonth: Left(failure),
            yAxis: tYAxis,
          ),
        );
      },
    );
  });
}
