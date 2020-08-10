import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/recent.dart';
import '../repositories/recently_added_repository.dart';

class GetRecentlyAdded {
  final RecentlyAddedRepository repository;

  GetRecentlyAdded({@required this.repository});

  Future<Either<Failure, List<RecentItem>>> call({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
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
