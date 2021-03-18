import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

/// Returns a Map of the decoded JSON response from
/// the `get_users_table` endpoint.
///
/// Throws a [JsonDecodeException] if the json decode fails.
abstract class GetUsersTable {
  Future<Map<String, dynamic>> call({
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

class GetUsersTableImpl implements GetUsersTable {
  final ConnectionHandler connectionHandler;

  GetUsersTableImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, String> params = {};

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (orderColumn != null) {
      params['order_column'] = orderColumn;
    }
    if (orderDir != null) {
      params['order_dir'] = orderDir;
    }
    if (start != null) {
      params['start'] = start.toString();
    }
    if (length != null) {
      params['length'] = length.toString();
    }
    if (search != null) {
      params['search'] = search;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_users_table',
      params: params,
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
