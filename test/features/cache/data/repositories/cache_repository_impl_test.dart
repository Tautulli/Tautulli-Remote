// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/cache/data/datasources/cache_data_source.dart';
import 'package:tautulli_remote/features/cache/data/repositories/cache_repository_impl.dart';

class MockCacheDataSource extends Mock implements CacheDataSource {}

void main() {
  CacheRepositoryImpl repository;
  MockCacheDataSource mockCacheDataSource;

  setUp(() {
    mockCacheDataSource = MockCacheDataSource();
    repository = CacheRepositoryImpl(
      dataSource: mockCacheDataSource,
    );
  });

  test(
    'should forward the call to the data source to clear cache',
    () async {
      // act
      await repository.clearCache();
      // assert
      verify(mockCacheDataSource.clearCache());
    },
  );
}
