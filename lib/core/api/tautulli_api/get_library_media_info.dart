import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetLibraryMediaInfo {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir,
    int start,
    int length,
    bool refresh,
    int timeoutOverride,
  });
}

class GetLibraryMediaInfoImpl implements GetLibraryMediaInfo {
  final ConnectionHandler connectionHandler;

  GetLibraryMediaInfoImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir,
    int start,
    int length,
    bool refresh,
    int timeoutOverride,
  }) async {
    Map<String, String> params = {};

    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (sectionId != null) {
      params['section_id'] = sectionId.toString();
    }
    if (refresh != null) {
      params['refresh'] = refresh.toString();
    }
    if (orderDir != null) {
      params['order_dir'] = orderDir;
    }
    if (start != null) {
      params['start'] = start.toString();
    }
    if (length != null) {
      params['length'] = length.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_library_media_info',
      params: params,
      timeoutOverride: timeoutOverride,
    );

    return responseJson;
  }
}
