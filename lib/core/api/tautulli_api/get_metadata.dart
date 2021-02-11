import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetMetadata {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  });
}

class GetMetadataImpl implements GetMetadata {
  final ConnectionHandler connectionHandler;

  GetMetadataImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  }) async {
    Map<String, String> params = {};

    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (syncId != null) {
      params['sync_id'] = syncId.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_metadata',
      params: params,
    );

    return responseJson;
  }
}
