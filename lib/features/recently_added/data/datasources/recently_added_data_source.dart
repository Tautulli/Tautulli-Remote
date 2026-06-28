// ignore_for_file: use_null_aware_elements

import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
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
  final TautulliConnectionAdapter adapter;

  RecentlyAddedDataSourceImpl({required this.adapter});

  @override
  Future<Tuple2<List<RecentlyAddedModel>, bool>> getRecentlyAdded({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_recently_added', params: {
        'count': count,
        if (start != null) 'start': start,
        if (mediaType != null) 'media_type': mediaType.value,
        if (sectionId != null) 'section_id': sectionId,
      }),
    );

    final List<RecentlyAddedModel> recentList = result.data['data']['recently_added']
        .map<RecentlyAddedModel>((item) => RecentlyAddedModel.fromJson(item))
        .toList();

    return Tuple2(recentList, result.primaryActive);
  }
}
