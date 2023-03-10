import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/media_model.dart';

abstract class MediaRepository {
  Future<Either<Failure, Tuple2<MediaModel, bool>>> getMetadata({
    required String tautulliId,
    required int ratingKey,
  });
  Future<Either<Failure, Tuple2<List<MediaModel>, bool>>> getChildrenMetadata({
    required String tautulliId,
    required int ratingKey,
  });
}
