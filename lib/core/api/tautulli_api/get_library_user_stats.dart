// @dart=2.9

import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetLibraryUserStats {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  });
}

class GetLibraryUserStatsImpl implements GetLibraryUserStats {
  final ConnectionHandler connectionHandler;

  GetLibraryUserStatsImpl({
    @required this.connectionHandler,
  });

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_library_user_stats',
      params: {
        'section_id': sectionId.toString(),
      },
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
