import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../models/user_model.dart';
import '../models/user_player_stat_model.dart';
import '../models/user_watch_time_stat_model.dart';

abstract class UsersDataSource {
  Future<Tuple2<List<UserPlayerStatModel>, bool>> getPlayerStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
  });

  Future<Tuple2<List<UserWatchTimeStatModel>, bool>> getWatchTimeStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  });

  Future<Tuple2<List<UserModel>, bool>> getUsers({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });
}

class UsersDataSourceImpl implements UsersDataSource {
  final GetUserPlayerStats getUserPlayerStats;
  final GetUserWatchTimeStats getUserWatchTimeStats;
  final GetUsersTable getUsersTableApi;

  UsersDataSourceImpl({
    required this.getUserPlayerStats,
    required this.getUserWatchTimeStats,
    required this.getUsersTableApi,
  });

  @override
  Future<Tuple2<List<UserPlayerStatModel>, bool>> getPlayerStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
  }) async {
    final result = await getUserPlayerStats(
      tautulliId: tautulliId,
      userId: userId,
      grouping: grouping,
    );

    final List<UserPlayerStatModel> playerStatList = result.value1['response']
            ['data']
        .map<UserPlayerStatModel>(
            (playerStat) => UserPlayerStatModel.fromJson(playerStat))
        .toList();

    return Tuple2(playerStatList, result.value2);
  }

  @override
  Future<Tuple2<List<UserWatchTimeStatModel>, bool>> getWatchTimeStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  }) async {
    final result = await getUserWatchTimeStats(
      tautulliId: tautulliId,
      userId: userId,
      grouping: grouping,
      queryDays: queryDays,
    );

    final List<UserWatchTimeStatModel> watchTimeStatList = result
        .value1['response']['data']
        .map<UserWatchTimeStatModel>(
            (watchTimeStat) => UserWatchTimeStatModel.fromJson(watchTimeStat))
        .toList();

    return Tuple2(watchTimeStatList, result.value2);
  }

  @override
  Future<Tuple2<List<UserModel>, bool>> getUsers({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    final result = await getUsersTableApi(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );

    final List<UserModel> userList = result.value1['response']['data']['data']
        .map<UserModel>((user) => UserModel.fromJson(user))
        .toList();

    return Tuple2(userList, result.value2);
  }
}
