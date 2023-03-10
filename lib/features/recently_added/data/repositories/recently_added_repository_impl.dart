import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/media_type.dart';
import '../../domain/repositories/recently_added_repository.dart';
import '../datasources/recently_added_data_source.dart';
import '../models/recently_added_model.dart';

class RecentlyAddedRepositoryImpl implements RecentlyAddedRepository {
  final RecentlyAddedDataSource dataSource;
  final NetworkInfo networkInfo;

  RecentlyAddedRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<List<RecentlyAddedModel>, bool>>>
      getRecentlyAdded({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getRecentlyAdded(
          tautulliId: tautulliId,
          count: count,
          start: start,
          mediaType: mediaType,
          sectionId: sectionId,
        );

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
