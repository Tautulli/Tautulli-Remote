import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class UsersDataSource {
  Future<List> getUsers({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  });
}

class UsersDataSourceImpl implements UsersDataSource {
  final TautulliApi tautulliApi;

  UsersDataSourceImpl({@required this.tautulliApi});

  @override
  Future<List> getUsers({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    final usersJson = await tautulliApi.getUsersTable(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );

    final List<User> recentList = [];
    usersJson['response']['data']['data'].forEach((item) {
      recentList.add(UserModel.fromJson(item));
    });

    return recentList;
  }
}
