import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/recent.dart';

abstract class RecentlyAddedRepository {
  Future<Either<Failure, List<RecentItem>>> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
  });
}
