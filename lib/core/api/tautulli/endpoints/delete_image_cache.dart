import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class DeleteImageCache {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  });
}

class DeleteImageCacheImpl implements DeleteImageCache {
  final ConnectionHandler connectionHandler;

  DeleteImageCacheImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  }) {
    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'delete_image_cache',
      params: {},
    );

    return response;
  }
}
