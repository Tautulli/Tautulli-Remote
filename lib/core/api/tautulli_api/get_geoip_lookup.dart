import 'package:meta/meta.dart';

import 'connection_handler.dart';

/// Returns a Map of the decoded JSON response from
/// the `get_geoip_lookup` endpoint.
///
/// Throws a [JsonDecodeException] if the json decode fails.
abstract class GetGeoipLookup {
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String ipAddress,
  });
}

class GetGeoipLookupImpl implements GetGeoipLookup {
  final ConnectionHandler connectionHandler;

  GetGeoipLookupImpl({@required this.connectionHandler});

  @override
  Future<Map<String, dynamic>> call({
    @required String tautulliId,
    @required String ipAddress,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_geoip_lookup',
      params: {'ip_address': ipAddress},
    );

    return responseJson;
  }
}
