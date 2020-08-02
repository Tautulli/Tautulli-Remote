import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../features/settings/domain/usecases/settings.dart';
import '../database/domain/entities/server.dart';
import '../error/exception.dart';

abstract class TautulliApi {
  Future connectionHandler();
  Future fetchTautulli();
  Future<Map<String, dynamic>> getActivity(String tautulliId);
  Future<Map<String, dynamic>> getGeoipLookup({
    @required String tautulliId,
    String ipAddress,
  });
  Future<String> pmsImageProxy({
    @required String tautulliId,
    String img,
    int ratingKey,
    int width,
    int height = 300,
    int opacity,
    int background,
    int blur,
    String fallback,
  });
  Future<Map<String, dynamic>> registerDevice({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
    @required String deviceName,
    @required String onesignalId,
  });
  Future<Map<String, dynamic>> terminateSession({
    @required String tautulliId,
    @required String sessionId,
    String message,
  });
}

class TautulliApiImpl implements TautulliApi {
  final http.Client client;
  final Settings settings;

  TautulliApiImpl({
    @required this.client,
    @required this.settings,
  });

  /// Handles failing over to the secondary connection if needed.
  /// Should not be called directly.
  Future connectionHandler({
    String tautulliId,
    String primaryConnectionProtocol,
    String primaryConnectionDomain,
    String primaryConnectionPath,
    String deviceToken,
    @required String cmd,
    Map<String, String> params,
  }) async {
    String secondaryConnectionAddress;
    String secondaryConnectionProtocol;
    String secondaryConnectionDomain;
    String secondaryConnectionPath;

    // If tautulliId is provided then query for existing server info
    if (tautulliId != null) {
      final Server server = await settings.getServerByTautulliId(tautulliId);
      primaryConnectionProtocol = server.primaryConnectionProtocol;
      primaryConnectionDomain = server.primaryConnectionDomain;
      primaryConnectionPath = server.primaryConnectionPath;
      secondaryConnectionAddress = server.secondaryConnectionAddress;
      secondaryConnectionProtocol = server.secondaryConnectionProtocol;
      secondaryConnectionDomain = server.secondaryConnectionDomain;
      secondaryConnectionPath = server.secondaryConnectionPath;
      deviceToken = server.deviceToken;

      // Verify server has primaryConnectionAddress and deviceToken
      if (isEmpty(server.primaryConnectionAddress) ||
          isEmpty(server.deviceToken)) {
        throw SettingsException();
      }
    }
    // If no tautulliId and any primaryConnection options
    // are missing throw SettingsException.
    else if (isEmpty(primaryConnectionProtocol) ||
        isEmpty(primaryConnectionDomain) ||
        isEmpty(deviceToken)) {
      throw SettingsException();
    }

    var response;

    // Attempt to connect using primary connection
    try {
      response = await fetchTautulli(
        connectionProtocol: primaryConnectionProtocol,
        connectionDomain: primaryConnectionDomain,
        connectionPath: primaryConnectionPath,
        deviceToken: deviceToken,
        cmd: cmd,
        params: params,
      );
    } catch (error) {
      // If secondary connection configured try again with that address
      if (isNotEmpty(secondaryConnectionAddress)) {
        //? Does this need to be caught if we want the error to actually be thrown
        //? Probably not
        response = await fetchTautulli(
          connectionProtocol: secondaryConnectionProtocol,
          connectionDomain: secondaryConnectionDomain,
          connectionPath: secondaryConnectionPath,
          deviceToken: deviceToken,
          cmd: cmd,
          params: params,
        );
      } else {
        // Re-throw caught error if no secondary connection
        throw error;
      }
    }
    return response;
  }

  /// Default constructor for Tautulli API endpoints.
  /// Should not be called directly.
  Future fetchTautulli({
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

    //* Return URI for pmsImageProxy if URI is good
    if (cmd == 'pms_image_proxy') {
      final uriCheck = await client.head(uri);
      if (uriCheck.statusCode != 200) {
        throw ServerException();
      }
      return uri;
    }

    // Call API using constructed URI
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    ).timeout(Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw ServerException();
    }

    // Attempt to parse reponse into JSON
    Map<String, dynamic> responseJson;
    try {
      responseJson = json.decode(response.body);
    } catch (_) {
      throw JsonDecodeException();
    }

    return responseJson;
  }

  /// Returns a Map of the decoded JSON response from
  /// the `get_activity` endpoint.
  ///
  /// Throws a [JsonDecodeException] if the json decode fails.
  Future<Map<String, dynamic>> getActivity(String tautulliId) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_activity',
    );

    return responseJson;
  }

  /// Returns a Map of the decoded JSON response from
  /// the `get_geoip_lookup` endpoint.
  ///
  /// Throws a [JsonDecodeException] if the json decode fails.
  Future<Map<String, dynamic>> getGeoipLookup({
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

  /// Returns a constructed URL as a String for accessing an
  /// image via the `pms_image_proxy` endpoint.
  Future<String> pmsImageProxy({
    @required String tautulliId,
    String img,
    int ratingKey,
    int width,
    int height = 300,
    int opacity,
    int background,
    int blur,
    String fallback,
  }) async {
    final Uri uri = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'pms_image_proxy',
      params: {
        'img': img,
        'rating_key': ratingKey.toString(),
        'width': width.toString(),
        'height': height.toString(),
        'opacity': opacity.toString(),
        'background': background.toString(),
        'blur': blur.toString(),
        'fallback': fallback,
      },
    );
    return uri.toString();
  }

  Future<Map<String, dynamic>> registerDevice({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
    @required String deviceName,
    @required String onesignalId,
  }) async {
    final responseJson = await connectionHandler(
      primaryConnectionProtocol: connectionProtocol,
      primaryConnectionDomain: connectionDomain,
      primaryConnectionPath: connectionPath,
      deviceToken: deviceToken,
      cmd: 'register_device',
      params: {
        'device_name': deviceName,
        'device_id': deviceId,
        'onesignal_id': onesignalId,
      },
    );

    return responseJson;
  }

  Future<Map<String, dynamic>> terminateSession({
    @required String tautulliId,
    @required String sessionId,
    String message,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'terminate_session',
      params: {
        'session_id': sessionId,
        'message': message,
      },
    );

    return responseJson;
  }
}
