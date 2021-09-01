// @dart=2.9

import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

abstract class GetChildrenMetadata {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
    @required SettingsBloc settingsBloc,
  });
}

class GetChildrenMetadataImpl implements GetChildrenMetadata {
  final ConnectionHandler connectionHandler;

  GetChildrenMetadataImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, String> params = {
      'rating_key': ratingKey.toString(),
    };

    if (mediaType != null) {
      params['media_type'] = mediaType;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_children_metadata',
      params: params,
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
