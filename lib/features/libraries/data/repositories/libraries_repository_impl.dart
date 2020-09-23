import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/library.dart';
import '../../domain/repositories/libraries_repository.dart';
import '../datasources/libraries_data_source.dart';

class LibrariesRepositoryImpl implements LibrariesRepository {
  final LibrariesDataSource dataSource;
  final NetworkInfo networkInfo;
  final FailureMapperHelper failureMapperHelper;

  LibrariesRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
    @required this.failureMapperHelper,
  });

  @override
  Future<Either<Failure, List<Library>>> getLibrariesTable({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final librariesList = await dataSource.getLibrariesTable(
          tautulliId: tautulliId,
          grouping: grouping,
          length: length,
          orderColumn: orderColumn,
          orderDir: orderDir,
          search: search,
          start: start,
        );
        return Right(librariesList);
      } catch (exception) {
        final Failure failure =
            failureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
