import 'package:dartz/dartz.dart';
import 'package:quiver/strings.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
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
  final GetMetadata getMetadataApi;
  final GetChildrenMetadata getChildrenMetadataApi;

  MediaDataSourceImpl({
    required this.getMetadataApi,
    required this.getChildrenMetadataApi,
  });

  @override
  Future<Tuple2<MediaModel, bool>> getMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    final result = await getMetadataApi(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
    );

    final metadata = MediaModel.fromJson(result.value1['response']['data']);

    return Tuple2(metadata, result.value2);
  }

  @override
  Future<Tuple2<List<MediaModel>, bool>> getChildrenMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    final result = await getChildrenMetadataApi(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
    );

    final List<MediaModel> childrenList =
        result.value1['response']['data']['children_list'].map<MediaModel>((childItem) {
      final mediaModel = MediaModel.fromJson(childItem);

      // Insert parent title for photos when missing
      if ([MediaType.photo, MediaType.clip].contains(mediaModel.mediaType) &&
          isBlank(mediaModel.parentTitle) &&
          isNotBlank(result.value1['response']['data']['title'])) {
        return mediaModel.copyWith(parentTitle: result.value1['response']['data']['title']);
      } else {
        return mediaModel;
      }
    }).toList();

    // Do not include the "All episodes" season Tautulli returns
    if (childrenList[0].mediaType == MediaType.unknown) {
      childrenList.removeAt(0);
    }

    return Tuple2(childrenList, result.value2);
  }
}
