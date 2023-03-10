import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetMetadata {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int ratingKey,
  });
}

class GetMetadataImpl implements GetMetadata {
  final ConnectionHandler connectionHandler;

  GetMetadataImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int ratingKey,
  }) {
    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_metadata',
      params: {'rating_key': ratingKey},
    );

    return response;
  }
}
