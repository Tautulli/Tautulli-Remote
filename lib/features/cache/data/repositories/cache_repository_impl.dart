import 'package:meta/meta.dart';

import '../../domain/repositories/cache_repository.dart';
import '../datasources/cache_data_source.dart';

class CacheRepositoryImpl implements CacheRepository {
  final CacheDataSource dataSource;

  CacheRepositoryImpl({@required this.dataSource});

  @override
  Future<void> clearCache() async {
    return await dataSource.clearCache();
  }
}
