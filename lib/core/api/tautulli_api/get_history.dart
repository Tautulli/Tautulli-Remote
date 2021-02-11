import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetHistory {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  });
}

class GetHistoryImpl implements GetHistory {
  final ConnectionHandler connectionHandler;

  GetHistoryImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    Map<String, String> params = {
      'include_activity': 'false',
    };

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (user != null) {
      params['user'] = user;
    }
    if (userId != null) {
      params['user_id'] = userId.toString();
    }
    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (parentRatingKey != null) {
      params['parent_rating_key'] = parentRatingKey.toString();
    }
    if (grandparentRatingKey != null) {
      params['grandparent_rating_key'] = grandparentRatingKey.toString();
    }
    if (startDate != null) {
      params['start_date'] = startDate;
    }
    if (sectionId != null) {
      params['section_id'] = sectionId.toString();
    }
    if (mediaType != null) {
      params['media_type'] = mediaType;
    }
    if (transcodeDecision != null) {
      params['transcode_decision'] = transcodeDecision;
    }
    if (guid != null) {
      params['guid'] = guid;
    }
    if (orderColumn != null) {
      params['order_column'] = orderColumn;
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
    if (search != null) {
      params['search'] = search;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_history',
      params: params,
    );

    return responseJson;
  }
}
