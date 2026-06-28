// ignore_for_file: use_null_aware_elements

import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
import '../models/user_model.dart';
import '../models/user_player_stat_model.dart';
import '../models/user_table_model.dart';
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

  Future<Tuple2<UserModel, bool>> getUser({
    required String tautulliId,
    required int userId,
    bool? includeLastSeen,
  });

  Future<Tuple2<List<UserModel>, bool>> getUserNames({
    required String tautulliId,
  });

  Future<Tuple2<List<UserTableModel>, bool>> getUsersTable({
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
  final TautulliConnectionAdapter adapter;

  UsersDataSourceImpl({required this.adapter});

  @override
  Future<Tuple2<List<UserPlayerStatModel>, bool>> getPlayerStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_user_player_stats', params: {
        'user_id': userId,
        if (grouping != null) 'grouping': grouping ? 1 : 0,
      }),
    );

    final List<UserPlayerStatModel> playerStatList = result.data['data']
        .map<UserPlayerStatModel>((item) => UserPlayerStatModel.fromJson(item))
        .toList();

    return Tuple2(playerStatList, result.primaryActive);
  }

  @override
  Future<Tuple2<List<UserWatchTimeStatModel>, bool>> getWatchTimeStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_user_watch_time_stats', params: {
        'user_id': userId,
        if (grouping != null) 'grouping': grouping ? 1 : 0,
        if (queryDays != null) 'query_days': queryDays,
      }),
    );

    final List<UserWatchTimeStatModel> watchTimeStatList = result.data['data']
        .map<UserWatchTimeStatModel>((item) => UserWatchTimeStatModel.fromJson(item))
        .toList();

    return Tuple2(watchTimeStatList, result.primaryActive);
  }

  @override
  Future<Tuple2<UserModel, bool>> getUser({
    required String tautulliId,
    required int userId,
    bool? includeLastSeen,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_user', params: {
        'user_id': userId,
        if (includeLastSeen != null) 'include_last_seen': includeLastSeen ? 1 : 0,
      }),
    );

    return Tuple2(UserModel.fromJson(result.data['data']), result.primaryActive);
  }

  @override
  Future<Tuple2<List<UserModel>, bool>> getUserNames({
    required String tautulliId,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_user_names'),
    );

    final List<UserModel> userList =
        result.data['data'].map<UserModel>((item) => UserModel.fromJson(item)).toList();

    return Tuple2(userList, result.primaryActive);
  }

  @override
  Future<Tuple2<List<UserTableModel>, bool>> getUsersTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_users_table', params: {
        if (grouping != null) 'grouping': grouping ? 1 : 0,
        if (orderColumn != null) 'order_column': orderColumn,
        if (orderDir != null) 'order_dir': orderDir,
        if (start != null) 'start': start,
        if (length != null) 'length': length,
        if (search != null) 'search': search,
      }),
    );

    final List<UserTableModel> userTableList = result.data['data']['data']
        .map<UserTableModel>((item) => UserTableModel.fromJson(item))
        .toList();

    return Tuple2(userTableList, result.primaryActive);
  }
}
