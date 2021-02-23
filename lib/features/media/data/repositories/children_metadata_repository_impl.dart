import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/metadata_item.dart';
import '../../domain/repositories/children_metadata_repository.dart';
import '../datasources/children_metadata_data_source.dart';

class ChildrenMetadataRepositoryImpl implements ChildrenMetadataRepository {
  final ChildrenMetadataDataSource dataSource;
  final NetworkInfo networkInfo;

  ChildrenMetadataRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MetadataItem>>> getChildrenMetadata({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final List<MetadataItem> childrenMetadataList =
            await dataSource.getChildrenMetadata(
          tautulliId: tautulliId,
          ratingKey: ratingKey,
          mediaType: mediaType,
        );
        return Right(childrenMetadataList);
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
