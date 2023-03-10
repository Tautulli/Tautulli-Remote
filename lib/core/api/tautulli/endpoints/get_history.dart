import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetHistory {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    bool? grouping,
    bool? includeActivity,
    String? user,
    int? userId,
    int? ratingKey,
    int? parentRatingKey,
    int? grandparentRatingKey,
    DateTime? startDate,
    DateTime? before,
    DateTime? after,
    int? sectionId,
    String? mediaType,
    String? transcodeDecision,
    String? guid,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });
}

class GetHistoryImpl implements GetHistory {
  final ConnectionHandler connectionHandler;

  GetHistoryImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    bool? grouping,
    bool? includeActivity,
    String? user,
    int? userId,
    int? ratingKey,
    int? parentRatingKey,
    int? grandparentRatingKey,
    DateTime? startDate,
    DateTime? before,
    DateTime? after,
    int? sectionId,
    String? mediaType,
    String? transcodeDecision,
    String? guid,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) {
    Map<String, dynamic> params = {};
    if (grouping != null) params['grouping'] = grouping;
    if (includeActivity != null) params['include_activity'] = includeActivity;
    if (user != null) params['user'] = user;
    if (userId != null) params['user_id'] = userId;
    if (ratingKey != null) params['rating_key'] = ratingKey;
    if (parentRatingKey != null) params['parent_rating_key'] = parentRatingKey;
    if (grandparentRatingKey != null) params['grandparent_rating_key'] = grandparentRatingKey;
    if (startDate != null) params['start_date'] = startDate;
    if (before != null) params['before'] = before;
    if (after != null) params['after'] = after;
    if (sectionId != null) params['section_id'] = sectionId;
    if (mediaType != null) params['media_type'] = mediaType;
    if (transcodeDecision != null) params['transcode_decision'] = transcodeDecision;
    if (guid != null) params['guid'] = guid;
    if (orderColumn != null) params['order_column'] = orderColumn;
    if (orderDir != null) params['order_dir'] = orderDir;
    if (start != null) params['start'] = start;
    if (length != null) params['length'] = length;
    if (search != null) params['search'] = search;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_history',
      params: params,
    );

    return response;
  }
}
