import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract class ManageCache {
  Future<void> clearCache();
}

class ManageCacheImpl implements ManageCache {
  final DefaultCacheManager cacheManager;

  ManageCacheImpl(this.cacheManager);

  @override
  Future<void> clearCache() async {
    return await cacheManager.emptyCache();
  }
}
