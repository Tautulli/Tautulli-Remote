import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetChildrenMetadata {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int ratingKey,
  });
}

class GetChildrenMetadataImpl implements GetChildrenMetadata {
  final ConnectionHandler connectionHandler;

  GetChildrenMetadataImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int ratingKey,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_children_metadata',
      params: {
        'rating_key': ratingKey.toString(),
      },
    );

    return responseJson;
  }
}
