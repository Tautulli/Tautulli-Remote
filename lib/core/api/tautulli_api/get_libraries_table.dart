import 'package:meta/meta.dart';

import 'connection_handler.dart';

abstract class GetLibrariesTable {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  });
}

class GetLibrariesTableImpl implements GetLibrariesTable {
  final ConnectionHandler connectionHandler;

  GetLibrariesTableImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  }) async {
    Map<String, String> params = {};

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (length != null) {
      params['length'] = length.toString();
    }
    if (orderColumn != null) {
      params['order_column'] = orderColumn;
    }
    if (orderDir != null) {
      params['order_dir'] = orderDir;
    }
    if (search != null) {
      params['search'] = search;
    }
    if (start != null) {
      params['start'] = start.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_libraries_table',
      params: params,
    );

    return responseJson;
  }
}
