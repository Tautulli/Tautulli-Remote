import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../features/settings/domain/usecases/settings.dart';
import '../../../injection_container.dart' as di;
import '../../error/exception.dart';

/// Default constructor for Tautulli API endpoints.
/// Should not be called directly.
abstract class CallTautulli {
  Future call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String cmd,
    Map<String, String> params,
  });
}

class CallTautulliImpl implements CallTautulli {
  final http.Client client;

  CallTautulliImpl({@required this.client});

  @override
  Future call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String cmd,
    Map<String, String> params,
  }) async {
    // If no params provided initalize params
    if (params == null) {
      params = {};
    }
    params['cmd'] = cmd;
    params['apikey'] = deviceToken;
    params['app'] = 'true';

    // Construct URI based on connection protocol using the connection domain/path as well as the params
    Uri uri;
    switch (connectionProtocol) {
      case ('http'):
        uri = Uri.http('$connectionDomain', '$connectionPath/api/v2', params);
        break;
      case ('https'):
        uri = Uri.https('$connectionDomain', '$connectionPath/api/v2', params);
    }

    //* Return URI for pmsImageProxy
    if (cmd == 'pms_image_proxy') {
      return uri;
    }

    // Get timeout value from settings
    final timeout = await di.sl<Settings>().getServerTimeout();

    // Call API using constructed URI
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    ).timeout(Duration(seconds: timeout != null ? timeout : 5));

    // Attempt to parse reponse into JSON
    Map<String, dynamic> responseJson;
    try {
      responseJson = json.decode(response.body);
    } catch (_) {
      throw JsonDecodeException();
    }

    if (response.statusCode != 200) {
      RegExp badServerVersion = RegExp(
          r'^Device registration failed: Tautulli version v\d.\d.\d does not meet the minimum requirement of v\d.\d.\d.');

      if (responseJson['response']['message'] != null &&
          badServerVersion.hasMatch(responseJson['response']['message'])) {
        throw ServerVersionException();
      }

      throw ServerException();
    }

    return responseJson;
  }
}
