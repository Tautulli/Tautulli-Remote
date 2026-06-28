import 'package:dartz/dartz.dart';
import 'package:quiver/strings.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
import '../../../../core/types/media_type.dart';
import '../models/media_model.dart';

abstract class MediaDataSource {
  Future<Tuple2<MediaModel, bool>> getMetadata({
    required String tautulliId,
    required int ratingKey,
  });
  Future<Tuple2<List<MediaModel>, bool>> getChildrenMetadata({
    required String tautulliId,
    required int ratingKey,
  });
}

class MediaDataSourceImpl implements MediaDataSource {
  final TautulliConnectionAdapter adapter;

  MediaDataSourceImpl({required this.adapter});

  @override
  Future<Tuple2<MediaModel, bool>> getMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_metadata', params: {
        'rating_key': ratingKey,
      }),
    );

    return Tuple2(MediaModel.fromJson(result.data['data']), result.primaryActive);
  }

  @override
  Future<Tuple2<List<MediaModel>, bool>> getChildrenMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_children_metadata', params: {
        'rating_key': ratingKey,
      }),
    );

    final responseData = result.data['data'];
    final List<MediaModel> childrenList =
        (responseData['children_list'] as List).map<MediaModel>((childItem) {
      final mediaModel = MediaModel.fromJson(childItem);

      if ([MediaType.photo, MediaType.clip].contains(mediaModel.mediaType) &&
          isBlank(mediaModel.parentTitle) &&
          isNotBlank(responseData['title'] as String?)) {
        return mediaModel.copyWith(parentTitle: responseData['title'] as String);
      } else {
        return mediaModel;
      }
    }).toList();

    if (childrenList.isNotEmpty && childrenList[0].mediaType == MediaType.unknown) {
      childrenList.removeAt(0);
    }

    return Tuple2(childrenList, result.primaryActive);
  }
}
