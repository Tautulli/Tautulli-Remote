import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/recent.dart';
import '../models/recent_model.dart';

abstract class RecentlyAddedDataSource {
  Future<List> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
  });
}

class RecentlyAddedDataSourceImpl implements RecentlyAddedDataSource {
  final TautulliApi tautulliApi;
  final Logging logging;

  RecentlyAddedDataSourceImpl({
    @required this.tautulliApi,
    @required this.logging,
  });

  @override
  Future<List> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
  }) async {
    final recentlyAddedJson = await tautulliApi.getRecentlyAdded(
      tautulliId: tautulliId,
      count: count,
      start: start,
      mediaType: mediaType,
      sectionId: sectionId,
    );
    final List<RecentItem> recentList = [];
    recentlyAddedJson['response']['data']['recently_added'].forEach((item) {
      recentList.add(RecentItemModel.fromJson(item));
    });

    return recentList;
  }
}
