import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/media_type.dart';
import '../../data/models/recently_added_model.dart';

abstract class RecentlyAddedRepository {
  Future<Either<Failure, Tuple2<List<RecentlyAddedModel>, bool>>>
      getRecentlyAdded({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  });
}
