import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../models/user_model.dart';

abstract class UsersDataSource {
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
  final GetUsersTable getUsersTableApi;

  UsersDataSourceImpl({
    required this.getUsersTableApi,
  });

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
