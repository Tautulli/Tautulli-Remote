import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/endpoints/get_history.dart';
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
  final GetHistory getHistoryApi;

  HistoryDataSourceImpl({
    required this.getHistoryApi,
  });

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
    final result = await getHistoryApi(
      tautulliId: tautulliId,
      grouping: grouping ?? true,
      includeActivity: includeActivity ?? false,
      user: user,
      userId: userId,
      ratingKey: ratingKey,
      parentRatingKey: parentRatingKey,
      grandparentRatingKey: grandparentRatingKey,
      startDate: startDate,
      before: before,
      after: after,
      sectionId: sectionId,
      mediaType: mediaType,
      transcodeDecision: transcodeDecision,
      guid: guid,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );

    final List<HistoryModel> historyList = result.value1['response']['data']
            ['data']
        .map<HistoryModel>((historyItem) => HistoryModel.fromJson(historyItem))
        .toList();

    return Tuple2(historyList, result.value2);
  }
}
