import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/recent.dart';
import '../../domain/repositories/recently_added_repository.dart';
import '../datasources/recently_added_data_source.dart';

class RecentlyAddedRepositoryImpl implements RecentlyAddedRepository {
  final RecentlyAddedDataSource dataSource;
  final NetworkInfo networkInfo;

  RecentlyAddedRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RecentItem>>> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final recentlyAddedList = await dataSource.getRecentlyAdded(
          tautulliId: tautulliId,
          count: count,
          start: start,
          mediaType: mediaType,
          sectionId: sectionId,
        );
        return Right(recentlyAddedList);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
