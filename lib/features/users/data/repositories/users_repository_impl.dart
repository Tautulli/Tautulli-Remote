import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_data_source.dart';
import '../models/user_model.dart';
import '../models/user_player_stat_model.dart';
import '../models/user_table_model.dart';
import '../models/user_watch_time_stat_model.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource dataSource;
  final NetworkInfo networkInfo;

  UsersRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<List<UserPlayerStatModel>, bool>>>
      getPlayerStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getPlayerStats(
          tautulliId: tautulliId,
          userId: userId,
          grouping: grouping,
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
  Future<Either<Failure, Tuple2<List<UserWatchTimeStatModel>, bool>>>
      getWatchTimeStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getWatchTimeStats(
          tautulliId: tautulliId,
          userId: userId,
          grouping: grouping,
          queryDays: queryDays,
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
  Future<Either<Failure, Tuple2<UserModel, bool>>> getUser({
    required String tautulliId,
    required int userId,
    bool? includeLastSeen,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getUser(
          tautulliId: tautulliId,
          userId: userId,
          includeLastSeen: includeLastSeen,
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
  Future<Either<Failure, Tuple2<List<UserModel>, bool>>> getUserNames({
    required String tautulliId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getUserNames(
          tautulliId: tautulliId,
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
  Future<Either<Failure, Tuple2<List<UserTableModel>, bool>>> getUsersTable({
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
        final result = await dataSource.getUsersTable(
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
