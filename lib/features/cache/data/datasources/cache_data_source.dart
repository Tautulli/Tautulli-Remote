import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';

abstract class CacheDataSource {
  Future<void> clearCache();
}

class CacheDataSourceImpl implements CacheDataSource {
  final DefaultCacheManager cacheManager;

  CacheDataSourceImpl({
    @required this.cacheManager,
  });

  @override
  Future<void> clearCache() async {
    return await cacheManager.emptyCache();
  }
}
