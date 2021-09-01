// @dart=2.9

import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';

import 'connection_handler.dart';

abstract class GetPlaysByTop10Users {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  });
}

class GetPlaysByTop10UsersImpl implements GetPlaysByTop10Users {
  final ConnectionHandler connectionHandler;

  GetPlaysByTop10UsersImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int timeRange,
    String yAxis,
    int userId,
    int grouping,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, String> params = {};

    if (timeRange != null) {
      params['time_range'] = timeRange.toString();
    }
    if (isNotEmpty(yAxis)) {
      params['y_axis'] = yAxis;
    }
    if (userId != null) {
      params['user_id'] = userId.toString();
    }
    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_plays_by_top_10_users',
      params: params,
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
