import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/media_type.dart';
import '../../data/models/recently_added_model.dart';
import '../repositories/recently_added_repository.dart';

class RecentlyAdded {
  final RecentlyAddedRepository repository;

  RecentlyAdded({
    required this.repository,
  });

  /// Returns a list of <RecentlyAddedModel>
  Future<Either<Failure, Tuple2<List<RecentlyAddedModel>, bool>>>
      getRecentlyAdded({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  }) async {
    return await repository.getRecentlyAdded(
      tautulliId: tautulliId,
      count: count,
      start: start,
      mediaType: mediaType,
      sectionId: sectionId,
    );
  }
}
