import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../models/media_model.dart';

abstract class MediaDataSource {
  Future<Tuple2<MediaModel, bool>> getMetadata({
    required String tautulliId,
    required int ratingKey,
  });
}

class MediaDataSourceImpl implements MediaDataSource {
  final GetMetadata getMetadataApi;

  MediaDataSourceImpl({
    required this.getMetadataApi,
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
}
