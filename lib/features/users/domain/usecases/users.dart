import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_player_stat_model.dart';
import '../../data/models/user_watch_time_stat_model.dart';
import '../repositories/users_repository.dart';

class Users {
  final UsersRepository repository;

  Users({required this.repository});

  /// Returns a list of player stats for the user with the provided `userId`.
  Future<Either<Failure, Tuple2<List<UserPlayerStatModel>, bool>>>
      getPlayerStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
  }) async {
    return await repository.getPlayerStats(
      tautulliId: tautulliId,
      userId: userId,
      grouping: grouping,
    );
  }

  /// Returns a list of watch time stats for the user with the provided `userId`.
  Future<Either<Failure, Tuple2<List<UserWatchTimeStatModel>, bool>>>
      getWatchTimeStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  }) async {
    return await repository.getWatchTimeStats(
      tautulliId: tautulliId,
      userId: userId,
      grouping: grouping,
      queryDays: queryDays,
    );
  }

  // Returns all Tautulli users as a list of `UserModel`.
  Future<Either<Failure, Tuple2<List<UserModel>, bool>>> getUsers({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    return await repository.getUsers(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );
  }
}
