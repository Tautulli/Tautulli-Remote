// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/cache/domain/usecases/clear_cache.dart';
import 'package:tautulli_remote/features/cache/presentation/bloc/cache_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';

class MockClearCache extends Mock implements ClearCache {}

class MockLogging extends Mock implements Logging {}

void main() {
  CacheBloc bloc;
  MockClearCache mockClearCache;
  MockLogging mockLogging;

  setUp(() {
    mockClearCache = MockClearCache();
    mockLogging = MockLogging();
    bloc = CacheBloc(
      clearCache: mockClearCache,
      logging: mockLogging,
    );
  });

  test(
    'initialState should be CacheInitial',
    () async {
      // assert
      expect(bloc.state, CacheInitial());
    },
  );

  group('ClearCache', () {
    test(
      'should call the ClearCache use case',
      () async {
        // act
        bloc.add(CacheClear());
        await untilCalled(mockClearCache());
        // assert
        verify(mockClearCache());
      },
    );

    test(
      'should emit [CacheInProgress, CacheSuccess] when cache is cleared',
      () async {
        // assert later
        final expected = [
          CacheInProgress(),
          CacheSuccess(),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(CacheClear());
      },
    );
  });
}
