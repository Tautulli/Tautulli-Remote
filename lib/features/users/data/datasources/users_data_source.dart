import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_table.dart';
import '../models/user_model.dart';
import '../models/user_table_model.dart';

abstract class UsersDataSource {
  Future<UserTable> getUser({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
  Future<List> getUserNames({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });
  Future<List> getUsersTable({
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  });
}

class UsersDataSourceImpl implements UsersDataSource {
  final tautulli_api.GetUser apiGetUser;
  final tautulli_api.GetUserNames apiGetUserNames;
  final tautulli_api.GetUsersTable apiGetUsersTable;

  UsersDataSourceImpl({
    @required this.apiGetUser,
    @required this.apiGetUserNames,
    @required this.apiGetUsersTable,
  });

  @override
  Future<UserTable> getUser({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    final userJson = await apiGetUser(
      tautulliId: tautulliId,
      userId: userId,
      settingsBloc: settingsBloc,
    );

    return UserTableModel.fromJson(userJson['response']['data']);
  }

  @override
  Future<List> getUserNames({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final usersJson = await apiGetUserNames(
      tautulliId: tautulliId,
      settingsBloc: settingsBloc,
    );

    final List<User> usersList = [];
    usersJson['response']['data'].forEach((item) {
      usersList.add(UserModel.fromJson(item));
    });

    return usersList;
  }

  @override
  Future<List> getUsersTable({
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  }) async {
    final usersTableJson = await apiGetUsersTable(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
      settingsBloc: settingsBloc,
    );

    final List<UserTable> usersTableList = [];
    usersTableJson['response']['data']['data'].forEach((item) {
      usersTableList.add(UserTableModel.fromJson(item));
    });

    return usersTableList;
  }
}
