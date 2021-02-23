import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/library_media.dart';
import '../../domain/repositories/library_media_repository.dart';
import '../datasources/library_media_data_source.dart';

class LibraryMediaRepositoryImpl implements LibraryMediaRepository {
  final LibraryMediaDataSource dataSource;
  final NetworkInfo networkInfo;

  LibraryMediaRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LibraryMedia>>> getLibraryMediaInfo({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir,
    int start,
    int length,
    bool refresh,
    int timeoutOverride,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final List<LibraryMedia> libraryMediaList =
            await dataSource.getLibraryMediaInfo(
          tautulliId: tautulliId,
          ratingKey: ratingKey,
          sectionId: sectionId,
          orderDir: orderDir,
          start: start,
          length: length,
          refresh: refresh,
          timeoutOverride: timeoutOverride,
        );
        return Right(libraryMediaList);
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
