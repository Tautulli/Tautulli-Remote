import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/repositories/logging_repository.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';

class MockLoggingRepository extends Mock implements LoggingRepository {}

void main() {
  Logging usecase;
  MockLoggingRepository mockLoggingRepository;

  setUp(() {
    mockLoggingRepository = MockLoggingRepository();
    usecase = Logging(
      repository: mockLoggingRepository,
    );
  });

  final String text = 'test log message';

  group('debug', () {
    test(
      'should forward to the repository',
      () async {
        // act
        usecase.debug(text);
        // assert
        verify(mockLoggingRepository.debug(text));
      },
    );
  });

  group('info', () {
    test(
      'should forward to the repository',
      () async {
        // act
        usecase.info(text);
        // assert
        verify(mockLoggingRepository.info(text));
      },
    );
  });

  group('warning', () {
    test(
      'should forward to the repository',
      () async {
        // act
        usecase.warning(text);
        // assert
        verify(mockLoggingRepository.warning(text));
      },
    );
  });

  group('error', () {
    test(
      'should forward to the repository',
      () async {
        // act
        usecase.error(text);
        // assert
        verify(mockLoggingRepository.error(text));
      },
    );
  });

  group('getAllLogs', () {
    test(
      'should forward to the repository',
      () async {
        // act
        usecase.getAllLogs();
        // assert
        verify(mockLoggingRepository.getAllLogs());
      },
    );
  });

  group('clearLogs', () {
    test(
      'should forward to the repository',
      () async {
        // act
        usecase.clearLogs();
        // assert
        verify(mockLoggingRepository.clearLogs());
      },
    );
  });

  group('exportLogs', () {
    test(
      'should forward to the repository',
      () async {
        // act
        usecase.exportLogs();
        // assert
        verify(mockLoggingRepository.exportLogs());
      },
    );
  });
}
