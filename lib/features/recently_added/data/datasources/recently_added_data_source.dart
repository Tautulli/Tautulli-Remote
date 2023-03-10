import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/endpoints/get_recently_added.dart';
import '../../../../core/types/media_type.dart';
import '../models/recently_added_model.dart';

abstract class RecentlyAddedDataSource {
  Future<Tuple2<List<RecentlyAddedModel>, bool>> getRecentlyAdded({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  });
}

class RecentlyAddedDataSourceImpl implements RecentlyAddedDataSource {
  final GetRecentlyAdded getRecentlyAddedApi;

  RecentlyAddedDataSourceImpl({
    required this.getRecentlyAddedApi,
  });

  @override
  Future<Tuple2<List<RecentlyAddedModel>, bool>> getRecentlyAdded({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  }) async {
    final result = await getRecentlyAddedApi(
      tautulliId: tautulliId,
      count: count,
      start: start,
      mediaType: mediaType,
      sectionId: sectionId,
    );

    final List<RecentlyAddedModel> recentList = result.value1['response']
            ['data']['recently_added']
        .map<RecentlyAddedModel>(
            (recentItem) => RecentlyAddedModel.fromJson(recentItem))
        .toList();

    return Tuple2(recentList, result.value2);
  }
}
