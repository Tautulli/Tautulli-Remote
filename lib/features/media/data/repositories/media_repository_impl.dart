import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/media_data_source.dart';
import '../models/media_model.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaDataSource dataSource;
  final NetworkInfo networkInfo;

  MediaRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<MediaModel, bool>>> getMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getMetadata(
          tautulliId: tautulliId,
          ratingKey: ratingKey,
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

  @override
  Future<Either<Failure, Tuple2<List<MediaModel>, bool>>> getChildrenMetadata({
    required String tautulliId,
    required int ratingKey,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getChildrenMetadata(
          tautulliId: tautulliId,
          ratingKey: ratingKey,
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
