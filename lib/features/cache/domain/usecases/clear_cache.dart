import '../repositories/cache_repository.dart';
import 'package:meta/meta.dart';

class ClearCache {
  final CacheRepository repository;

  ClearCache({@required this.repository});

  Future<void> call() async {
    return await repository.clearCache();
  }
}
