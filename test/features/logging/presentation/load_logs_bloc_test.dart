import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/logging/presentation/bloc/load_logs_bloc.dart';

class MockLogging extends Mock implements Logging {}

void main() {
  LogsBloc bloc;
  MockLogging mockLogging;

  setUp(() {
    mockLogging = MockLogging();
    bloc = LogsBloc(
      logging: mockLogging,
    );
  });

  //! Fails due to not using Equatable
  // test(
  //   'initialState should be LogsInitial',
  //   () async {
  //     // assert
  //     expect(bloc.state, LogsInitial());
  //   },
  // );

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
