import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/media_model.dart';
import '../repositories/media_repository.dart';

class Media {
  final MediaRepository repository;

  Media({required this.repository});

  /// Returns a `MediaModel` for the provided `ratingKey`.
  Future<Either<Failure, Tuple2<MediaModel, bool>>> getMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    return await repository.getMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
    );
  }

  /// Returns a list of `MediaModel`'s for the children of the provided `ratingKey`.
  Future<Either<Failure, Tuple2<List<MediaModel>, bool>>> getChildrenMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    return await repository.getChildrenMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
    );
  }
}
