import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/repositories/libraries_repository.dart';
import '../datasources/libraries_data_source.dart';
import '../models/library_table_model.dart';

class LibrariesRepositoryImpl implements LibrariesRepository {
  final LibrariesDataSource dataSource;
  final NetworkInfo networkInfo;

  LibrariesRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<List<LibraryTableModel>, bool>>>
      getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getLibrariesTable(
          tautulliId: tautulliId,
          grouping: grouping,
          orderColumn: orderColumn,
          orderDir: orderDir,
          start: start,
          length: length,
          search: search,
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
