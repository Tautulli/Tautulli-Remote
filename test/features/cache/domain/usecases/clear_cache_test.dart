// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/cache/domain/repositories/cache_repository.dart';
import 'package:tautulli_remote/features/cache/domain/usecases/clear_cache.dart';

class MockCacheRepository extends Mock implements CacheRepository {}

void main() {
  ClearCache clearCache;
  MockCacheRepository mockCacheRepository;

  setUp(() {
    mockCacheRepository = MockCacheRepository();
    clearCache = ClearCache(
      repository: mockCacheRepository,
    );
  });

  test(
    'clearCache should forward the request to the repository',
    () async {
      // act
      await clearCache();
      // assert
      verify(mockCacheRepository.clearCache());
    },
  );
}
