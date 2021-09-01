// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/data/datasources/logging_data_source.dart';
import 'package:tautulli_remote/features/logging/data/repositories/logging_repository_impl.dart';

class MockLoggingDataSource extends Mock implements LoggingDataSource {}

void main() {
  LoggingRepositoryImpl repository;
  MockLoggingDataSource mockLoggingDataSource;

  setUp(() {
    mockLoggingDataSource = MockLoggingDataSource();
    repository = LoggingRepositoryImpl(
      dataSource: mockLoggingDataSource,
    );
  });

  const String text = 'test log message';

  group('debug', () {
    test(
      'should call the data source',
      () async {
        // act
        repository.debug(text);
        // assert
        verify(mockLoggingDataSource.debug(text));
      },
    );
  });

  group('info', () {
    test(
      'should call the data source',
      () async {
        // act
        repository.info(text);
        // assert
        verify(mockLoggingDataSource.info(text));
      },
    );
  });

  group('warning', () {
    test(
      'should call the data source',
      () async {
        // act
        repository.warning(text);
        // assert
        verify(mockLoggingDataSource.warning(text));
      },
    );
  });

  group('error', () {
    test(
      'should call the data source',
      () async {
        // act
        repository.error(text);
        // assert
        verify(mockLoggingDataSource.error(text));
      },
    );
  });

  group('getAllLogs', () {
    test(
      'should call the data source',
      () async {
        // act
        await repository.getAllLogs();
        // assert
        verify(mockLoggingDataSource.getAllLogs());
      },
    );
  });

  group('clearLogs', () {
    test(
      'should call the data source',
      () async {
        // act
        repository.clearLogs();
        // assert
        verify(mockLoggingDataSource.clearLogs());
      },
    );
  });

  group('exportLogs', () {
    test(
      'should call the data source',
      () async {
        // act
        repository.exportLogs();
        // assert
        verify(mockLoggingDataSource.exportLogs());
      },
    );
  });
}
