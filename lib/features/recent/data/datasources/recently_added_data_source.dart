import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/recent.dart';
import '../models/recent_model.dart';

abstract class RecentlyAddedDataSource {
  Future<List> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
    @required SettingsBloc settingsBloc,
  });
}

class RecentlyAddedDataSourceImpl implements RecentlyAddedDataSource {
  final tautulliApi.GetRecentlyAdded apiGetRecentlyAdded;

  RecentlyAddedDataSourceImpl({
    @required this.apiGetRecentlyAdded,
  });

  @override
  Future<List> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    final recentlyAddedJson = await apiGetRecentlyAdded(
      tautulliId: tautulliId,
      count: count,
      start: start,
      mediaType: mediaType,
      sectionId: sectionId,
      settingsBloc: settingsBloc,
    );
    final List<RecentItem> recentList = [];
    recentlyAddedJson['response']['data']['recently_added'].forEach((item) {
      recentList.add(RecentItemModel.fromJson(item));
    });

    return recentList;
  }
}
