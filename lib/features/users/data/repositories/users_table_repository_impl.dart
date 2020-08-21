import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_table.dart';
import '../../domain/repositories/users_table_repository.dart';
import '../datasources/users_table_data_source.dart';

class UsersTableRepositoryImpl implements UsersTableRepository {
  final UsersTableDataSource dataSource;
  final NetworkInfo networkInfo;
  final FailureMapperHelper failureMapperHelper;

  UsersTableRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
    @required this.failureMapperHelper,
  });

  @override
  Future<Either<Failure, List<UserTable>>> getUsersTable({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final usersList = await dataSource.getUsersTable(
          tautulliId: tautulliId,
          grouping: grouping,
          orderColumn: orderColumn,
          orderDir: orderDir,
          start: start,
          length: length,
          search: search,
        );
        return Right(usersList);
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
