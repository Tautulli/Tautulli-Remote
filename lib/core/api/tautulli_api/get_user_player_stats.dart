// @dart=2.9

import 'package:flutter/material.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetUserPlayerStats {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
}

class GetUserPlayerStatsImpl implements GetUserPlayerStats {
  final ConnectionHandler connectionHandler;

  GetUserPlayerStatsImpl({
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
      cmd: 'get_user_player_stats',
      params: {
        'user_id': userId.toString(),
      },
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
