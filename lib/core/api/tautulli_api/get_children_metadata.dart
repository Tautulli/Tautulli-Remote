import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetChildrenMetadata {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
  });
}

class GetChildrenMetadataImpl implements GetChildrenMetadata {
  final ConnectionHandler connectionHandler;

  GetChildrenMetadataImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
  }) async {
    Map<String, String> params = {
      'rating_key': ratingKey.toString(),
    };

    if (mediaType != null) {
      params['media_type'] = mediaType;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_children_metadata',
      params: params,
    );

    return responseJson;
  }
}
