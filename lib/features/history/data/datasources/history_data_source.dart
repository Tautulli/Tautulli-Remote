import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/history.dart';
import '../models/history_model.dart';

abstract class HistoryDataSource {
  Future<List> getHistory({
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

class HistoryDataSourceImpl implements HistoryDataSource {
  final TautulliApi tautulliApi;
  final Logging logging;

  HistoryDataSourceImpl({
    @required this.tautulliApi,
    @required this.logging,
  });

  @override
  Future<List> getHistory({
    String tautulliId,
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
    final historyJson = await tautulliApi.getHistory(
      tautulliId: tautulliId,
      grouping: grouping,
      user: user,
      userId: userId,
      ratingKey: ratingKey,
      parentRatingKey: parentRatingKey,
      grandparentRatingKey: grandparentRatingKey,
      startDate: startDate,
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

    final List<History> historyList = [];
    historyJson['response']['data']['data'].forEach((item) {
      historyList.add(HistoryModel.fromJson(item));
    });

    return historyList;
  }
}
