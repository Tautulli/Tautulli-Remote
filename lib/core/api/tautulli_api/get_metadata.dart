import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetMetadata {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int ratingKey,
    int syncId,
    @required SettingsBloc settingsBloc,
  });
}

class GetMetadataImpl implements GetMetadata {
  final ConnectionHandler connectionHandler;

  GetMetadataImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    int ratingKey,
    int syncId,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, String> params = {};

    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (syncId != null) {
      params['sync_id'] = syncId.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_metadata',
      params: params,
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
