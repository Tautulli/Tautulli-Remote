import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../domain/entities/user_table.dart';
import '../models/user_table_model.dart';

abstract class UsersTableDataSource {
  Future<List> getUsersTable({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  });
}

class UsersTableDataSourceImpl implements UsersTableDataSource {
  final TautulliApi tautulliApi;

  UsersTableDataSourceImpl({@required this.tautulliApi});

  @override
  Future<List> getUsersTable({
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

    final List<UserTable> recentList = [];
    usersJson['response']['data']['data'].forEach((item) {
      recentList.add(UserTableModel.fromJson(item));
    });

    return recentList;
  }
}
