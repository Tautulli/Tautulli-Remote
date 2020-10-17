import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../features/logging/domain/usecases/logging.dart';
import '../../features/settings/domain/usecases/settings.dart';
import '../database/domain/entities/server.dart';
import '../error/exception.dart';
import '../requirements/versions.dart';

abstract class TautulliApi {
  Future connectionHandler();
  Future fetchTautulli();
  Future<Map<String, dynamic>> deleteMobileDevice({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
  });
  Future<Map<String, dynamic>> getActivity(String tautulliId);
  Future<Map<String, dynamic>> getGeoipLookup({
    @required String tautulliId,
    String ipAddress,
  });
  Future<Map<String, dynamic>> getHistory({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  });
  Future<Map<String, dynamic>> getHomeStats({
    @required String tautulliId,
    int grouping,
    int timeRange,
    String statsType,
    int statsStart,
    int statsCount,
    String statId,
  });
  Future<Map<String, dynamic>> getLibrariesTable({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  });
  Future<Map<String, dynamic>> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  });
  Future<Map<String, dynamic>> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
  });
  Future<Map<String, dynamic>> getServerInfo(String tautulliId);
  Future<Map<String, dynamic>> getSyncedItems({
    @required String tautulliId,
    String machineId,
    String userId,
  });
  Future<Map<String, dynamic>> getUserNames({
    @required String tautulliId,
  });
  Future<Map<String, dynamic>> getUsersTable({
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  });
  Future<String> pmsImageProxy({
    @required String tautulliId,
    String img,
    int ratingKey,
    int width,
    int height,
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
  final Logging logging;

  TautulliApiImpl({
    @required this.client,
    @required this.settings,
    @required this.logging,
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
    bool primaryActive;

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
      primaryActive = server.primaryActive;

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

    // If primaryActive has not been set default to true
    if (primaryActive == null) {
      primaryActive = true;
    }

    var response;

    // Attempt to connect using active connection
    try {
      response = await fetchTautulli(
        connectionProtocol: primaryActive
            ? primaryConnectionProtocol
            : secondaryConnectionProtocol,
        connectionDomain:
            primaryActive ? primaryConnectionDomain : secondaryConnectionDomain,
        connectionPath:
            primaryActive ? primaryConnectionPath : secondaryConnectionPath,
        deviceToken: deviceToken,
        cmd: cmd,
        params: params,
      );
    } catch (error) {
      // If secondary connection configured try again with the other connection
      if (isNotEmpty(secondaryConnectionAddress)) {
        try {
          if (primaryActive) {
            logging.warning(
                'ConnectionHandler: Primary connection failed switching to secondary');
          } else {
            logging.warning(
                'ConnectionHandler: Secondary connection failed switching to primary');
          }
          primaryActive = !primaryActive;

          response = await fetchTautulli(
            connectionProtocol: primaryActive
                ? primaryConnectionProtocol
                : secondaryConnectionProtocol,
            connectionDomain: primaryActive
                ? primaryConnectionDomain
                : secondaryConnectionDomain,
            connectionPath:
                primaryActive ? primaryConnectionPath : secondaryConnectionPath,
            deviceToken: deviceToken,
            cmd: cmd,
            params: params,
          );

          settings.updatePrimaryActive(
            tautulliId: tautulliId,
            primaryActive: primaryActive,
          );
        } catch (error) {
          // If both connections failed set primary active to true and throw error
          logging.warning('ConnectionHandler: Both connections failed');
          settings.updatePrimaryActive(
            tautulliId: tautulliId,
            primaryActive: true,
          );

          throw error;
        }
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

    //* Return URI for pmsImageProxy
    if (cmd == 'pms_image_proxy') {
      return uri;
    }

    // Get timeout value from settings
    final timeout = await settings.getServerTimeout();

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

  Future<Map<String, dynamic>> deleteMobileDevice({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    @required String deviceId,
  }) async {
    final responseJson = await connectionHandler(
      primaryConnectionProtocol: connectionProtocol,
      primaryConnectionDomain: connectionDomain,
      primaryConnectionPath: connectionPath,
      deviceToken: deviceToken,
      cmd: 'delete_mobile_device',
      params: {
        'device_id': deviceId,
      },
    );

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

  Future<Map<String, dynamic>> getHistory({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    Map<String, String> params = {
      'include_activity': 'false',
    };

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (user != null) {
      params['user'] = user;
    }
    if (userId != null) {
      params['user_id'] = userId.toString();
    }
    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (parentRatingKey != null) {
      params['parent_rating_key'] = parentRatingKey.toString();
    }
    if (grandparentRatingKey != null) {
      params['grandparent_rating_key'] = grandparentRatingKey.toString();
    }
    if (startDate != null) {
      params['start_date'] = startDate;
    }
    if (sectionId != null) {
      params['section_id'] = sectionId.toString();
    }
    if (mediaType != null) {
      params['media_type'] = mediaType;
    }
    if (transcodeDecision != null) {
      params['transcode_decision'] = transcodeDecision;
    }
    if (guid != null) {
      params['guid'] = guid;
    }
    if (orderColumn != null) {
      params['order_column'] = orderColumn;
    }
    if (orderDir != null) {
      params['order_dir'] = orderDir;
    }
    if (start != null) {
      params['start'] = start.toString();
    }
    if (length != null) {
      params['length'] = length.toString();
    }
    if (search != null) {
      params['search'] = search;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_history',
      params: params,
    );

    return responseJson;
  }

  Future<Map<String, dynamic>> getHomeStats(
      {@required String tautulliId,
      int grouping,
      int timeRange,
      String statsType,
      int statsStart,
      int statsCount,
      String statId}) async {
    Map<String, String> params = {};

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (timeRange != null) {
      params['time_range'] = timeRange.toString();
    }
    if (statsType != null) {
      params['stats_type'] = statsType;
    }
    if (statsStart != null) {
      params['stats_start'] = statsStart.toString();
    }
    if (statsCount != null) {
      params['stats_count'] = statsCount.toString();
    }
    if (statId != null) {
      params['stat_id'] = statId;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_home_stats',
      params: params,
    );

    return responseJson;
  }

  Future<Map<String, dynamic>> getLibrariesTable({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  }) async {
    Map<String, String> params = {};

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (length != null) {
      params['length'] = length.toString();
    }
    if (orderColumn != null) {
      params['order_column'] = orderColumn;
    }
    if (orderDir != null) {
      params['order_dir'] = orderDir;
    }
    if (search != null) {
      params['search'] = search;
    }
    if (start != null) {
      params['start'] = start.toString();
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_libraries_table',
      params: params,
    );

    return responseJson;
  }

  Future<Map<String, dynamic>> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
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
    );

    return responseJson;
  }

  /// Returns a Map of the decoded JSON response from
  /// the `get_recently_added` endpoint.
  ///
  /// Throws a [JsonDecodeException] if the json decode fails.
  Future<Map<String, dynamic>> getRecentlyAdded({
    @required String tautulliId,
    @required int count,
    int start,
    String mediaType,
    int sectionId,
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
    );

    return responseJson;
  }

  Future<Map<String, dynamic>> getServerInfo(String tautulliId) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_server_info',
    );

    return responseJson;
  }

  Future<Map<String, dynamic>> getSyncedItems({
    @required String tautulliId,
    String machineId,
    String userId,
  }) async {
    Map<String, String> params = {};

    if (machineId != null) {
      params['machine_id'] = machineId;
    }
    if (userId != null) {
      params['user_id'] = userId;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_synced_items',
      params: params,
    );

    return responseJson;
  }

  Future<Map<String, dynamic>> getUserNames({
    @required String tautulliId,
  }) async {
    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_user_names',
    );

    return responseJson;
  }

  /// Returns a Map of the decoded JSON response from
  /// the `get_users_table` endpoint.
  ///
  /// Throws a [JsonDecodeException] if the json decode fails.
  Future<Map<String, dynamic>> getUsersTable({
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    Map<String, String> params = {};

    if (grouping != null) {
      params['grouping'] = grouping.toString();
    }
    if (orderColumn != null) {
      params['order_column'] = orderColumn;
    }
    if (orderDir != null) {
      params['order_dir'] = orderDir;
    }
    if (start != null) {
      params['start'] = start.toString();
    }
    if (length != null) {
      params['length'] = length.toString();
    }
    if (search != null) {
      params['search'] = search;
    }

    final responseJson = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_users_table',
      params: params,
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
    int height,
    int opacity,
    int background,
    int blur,
    String fallback,
  }) async {
    Map<String, String> params = {
      'height': '300',
    };

    if (img != null) {
      params['img'] = img;
    }
    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (width != null) {
      params['width'] = width.toString();
    }
    if (height != null) {
      params['height'] = height.toString();
    }
    if (opacity != null) {
      params['opacity'] = opacity.toString();
    }
    if (background != null) {
      params['background'] = background.toString();
    }
    if (blur != null) {
      params['blur'] = blur.toString();
    }
    if (fallback != null) {
      params['fallback'] = fallback;
    }

    final Uri uri = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'pms_image_proxy',
      params: params,
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
        'min_version': 'v${MinimumVersion.tautulliServer}',
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
