import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';
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
    @required SettingsBloc settingsBloc,
  });
}

class HistoryDataSourceImpl implements HistoryDataSource {
  final tautulli_api.GetHistory apiGetHistory;

  HistoryDataSourceImpl({
    @required this.apiGetHistory,
  });

  @override
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
    @required SettingsBloc settingsBloc,
  }) async {
    final historyJson = await apiGetHistory(
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
      settingsBloc: settingsBloc,
    );

    final List<History> historyList = [];
    historyJson['response']['data']['data'].forEach((item) {
      historyList.add(HistoryModel.fromJson(item));
    });

    return historyList;
  }
}
