import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_table.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_data_source.dart';

class UsersTableRepositoryImpl implements UsersRepository {
  final UsersDataSource dataSource;
  final NetworkInfo networkInfo;

  UsersTableRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<User>>> getUserNames({
    @required tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final usersList = await dataSource.getUserNames(
          tautulliId: tautulliId,
          settingsBloc: settingsBloc,
        );
        return Right(usersList);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTable>>> getUsersTable({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final usersTableList = await dataSource.getUsersTable(
          tautulliId: tautulliId,
          grouping: grouping,
          orderColumn: orderColumn,
          orderDir: orderDir,
          start: start,
          length: length,
          search: search,
          settingsBloc: settingsBloc,
        );
        return Right(usersTableList);
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
