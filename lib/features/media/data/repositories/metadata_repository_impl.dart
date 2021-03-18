import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/metadata_item.dart';
import '../../domain/repositories/metadata_repository.dart';
import '../datasources/metadata_data_source.dart';

class MetadataRepositoryImpl implements MetadataRepository {
  final MetadataDataSource dataSource;
  final NetworkInfo networkInfo;

  MetadataRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, MetadataItem>> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final metadataItem = await dataSource.getMetadata(
          tautulliId: tautulliId,
          ratingKey: ratingKey,
          syncId: syncId,
          settingsBloc: settingsBloc,
        );
        return Right(metadataItem);
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
