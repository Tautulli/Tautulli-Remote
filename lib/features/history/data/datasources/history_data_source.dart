// ignore_for_file: use_null_aware_elements

import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
import '../models/history_model.dart';

abstract class HistoryDataSource {
  Future<Tuple2<List<HistoryModel>, bool>> getHistory({
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

class HistoryDataSourceImpl implements HistoryDataSource {
  final TautulliConnectionAdapter adapter;

  HistoryDataSourceImpl({required this.adapter});

  @override
  Future<Tuple2<List<HistoryModel>, bool>> getHistory({
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
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_history', params: {
        'grouping': grouping ?? true ? 1 : 0,
        'include_activity': includeActivity ?? false ? 1 : 0,
        if (user != null) 'user': user,
        if (userId != null) 'user_id': userId,
        if (ratingKey != null) 'rating_key': ratingKey,
        if (parentRatingKey != null) 'parent_rating_key': parentRatingKey,
        if (grandparentRatingKey != null) 'grandparent_rating_key': grandparentRatingKey,
        if (startDate != null) 'start_date': _formatDate(startDate),
        if (before != null) 'before': _formatDate(before),
        if (after != null) 'after': _formatDate(after),
        if (sectionId != null) 'section_id': sectionId,
        if (mediaType != null) 'media_type': mediaType,
        if (transcodeDecision != null) 'transcode_decision': transcodeDecision,
        if (guid != null) 'guid': guid,
        if (orderColumn != null) 'order_column': orderColumn,
        if (orderDir != null) 'order_dir': orderDir,
        if (start != null) 'start': start,
        if (length != null) 'length': length,
        if (search != null) 'search': search,
      }),
    );

    final List<HistoryModel> historyList = result.data['data']['data']
        .map<HistoryModel>((item) => HistoryModel.fromJson(item))
        .toList();

    return Tuple2(historyList, result.primaryActive);
  }

  static String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
