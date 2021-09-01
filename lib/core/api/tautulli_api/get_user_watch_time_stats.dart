// @dart=2.9

import 'package:flutter/material.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetUserWatchTimeStats {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
}

class GetUserWatchTimeStatsImpl implements GetUserWatchTimeStats {
  final ConnectionHandler connectionHandler;

  GetUserWatchTimeStatsImpl({
    @required this.connectionHandler,
  });

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user_watch_time_stats',
      params: {
        'user_id': userId.toString(),
      },
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
