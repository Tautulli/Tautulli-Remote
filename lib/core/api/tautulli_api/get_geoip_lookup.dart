// @dart=2.9

import 'package:meta/meta.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'connection_handler.dart';

/// Returns a Map of the decoded JSON response from
/// the `get_geoip_lookup` endpoint.
///
/// Throws a [JsonDecodeException] if the json decode fails.
abstract class GetGeoipLookup {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String ipAddress,
    @required SettingsBloc settingsBloc,
  });
}

class GetGeoipLookupImpl implements GetGeoipLookup {
  final ConnectionHandler connectionHandler;

  GetGeoipLookupImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String ipAddress,
    @required SettingsBloc settingsBloc,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_geoip_lookup',
      params: {'ip_address': ipAddress},
      settingsBloc: settingsBloc,
    );

    return responseJson;
  }
}
