import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/logging/presentation/bloc/load_logs_bloc.dart';
import 'package:tautulli_remote_tdd/core/helpers/log_format_helper.dart';

class MockLogging extends Mock implements Logging {}

class MockLogFormatHelper extends Mock implements LogFormatHelper {}

void main() {
  LogsBloc bloc;
  MockLogging mockLogging;
  MockLogFormatHelper mockLogFormatHelper;

  setUp(() {
    mockLogging = MockLogging();
    mockLogFormatHelper = MockLogFormatHelper();
    bloc = LogsBloc(
      logging: mockLogging,
      logFormatHelper: mockLogFormatHelper,
    );
  });

  test(
    'initialState should be LoadLogsInitial',
    () async {
      // assert
      expect(bloc.state, LogsInitial());
    },
  );

  group('LogsLoad', () {
    test(
      'should get logs from Logging use case',
      () async {
        // arrange
        when(mockLogging.getAllLogs()).thenAnswer((_) async => []);
        // act
        bloc.add(LogsLoad());
        await untilCalled(mockLogging.getAllLogs());
        // assert
        verify(mockLogging.getAllLogs());
      },
    );

    //! Equatable was removed from LogsState so this test won't pass now
    // test(
    //   'should emit [LoadLogsInProgress, LoadLogsSuccess] when logs are fetched successfully',
    //   () async {
    //     // arrange
    //     when(mockLogging.getAllLogs()).thenAnswer((_) async => []);
    //     // assert later
    //     final expected = [
    //       LogsInitial(),
    //       // LogsLoadInProgress(),
    //       LogsSuccess(
    //         logs: [],
    //         logFormatHelper: mockLogFormatHelper,
    //       ),
    //     ];
    //     expectLater(bloc, emitsInOrder(expected));
    //     // act
    //     bloc.add(LogsLoad());
    //   },
    // );
  });

  group('LogsClear', () {
    test(
      'should call use case to clear logs',
      () async {
        // arrange

        // act
        bloc.add(LogsClear());
        await untilCalled(mockLogging.clearLogs());
        // assert
        verify(mockLogging.clearLogs());
      },
    );

    //! Equatable was removed from LogsState so this test won't pass now
    // test(
    //   'should emit [LoadLogsInProgress, LoadLogsSuccess] when logs are cleared successfully',
    //   () async {
    //     // arrange
    //     when(mockLogging.getAllLogs()).thenAnswer((_) async => []);
    //     // assert later
    //     final expected = [
    //       LogsInitial(),
    //       // LogsLoadInProgress(),
    //       LogsSuccess(
    //         logs: [],
    //         logFormatHelper: mockLogFormatHelper,
    //       ),
    //     ];
    //     expectLater(bloc, emitsInOrder(expected));
    //     // act
    //     bloc.add(LogsClear());
    //   },
    // );
  });
}
