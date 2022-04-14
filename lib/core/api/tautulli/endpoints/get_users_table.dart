import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetUsersTable {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });
}

class GetUsersTableImpl implements GetUsersTable {
  final ConnectionHandler connectionHandler;

  GetUsersTableImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) {
    Map<String, dynamic> params = {};
    if (grouping != null) params['grouping'] = grouping;
    if (orderColumn != null) params['order_column'] = orderColumn;
    if (orderDir != null) params['order_dir'] = orderDir;
    if (start != null) params['start'] = start;
    if (length != null) params['length'] = length;
    if (search != null) params['search'] = search;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_users_table',
      params: params,
    );

    return response;
  }
}
