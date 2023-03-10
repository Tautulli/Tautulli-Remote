import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetChildrenMetadata {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int ratingKey,
  });
}

class GetChildrenMetadataImpl implements GetChildrenMetadata {
  final ConnectionHandler connectionHandler;

  GetChildrenMetadataImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int ratingKey,
  }) {
    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_children_metadata',
      params: {'rating_key': ratingKey},
    );

    return response;
  }
}
