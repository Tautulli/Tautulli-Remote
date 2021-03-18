import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

/// Returns a Map of the decoded JSON response from
/// the `get_recently_added` endpoint.
///
/// Throws a [JsonDecodeException] if the json decode fails.
abstract class GetRecentlyAdded {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
    @required SettingsBloc settingsBloc,
  });
}

class GetRecentlyAddedImpl implements GetRecentlyAdded {
  final ConnectionHandler connectionHandler;

  GetRecentlyAddedImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    Map<String, String> params = {'count': count.toString()};

    if (start != null) {
      params['start'] = start.toString();
    }
    if (isNotEmpty(mediaType)) {
      params['media_type'] = mediaType;
    }
    if (sectionId != null) {
      params['section_id'] = sectionId.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_recently_added',
      params: params,
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
