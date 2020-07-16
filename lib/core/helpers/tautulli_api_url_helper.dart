import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../features/settings/domain/usecases/get_settings.dart';
import '../error/exception.dart';

/// Provides various functions for constructing Tautulli API URLs.
abstract class TautulliApiUrls {
  /// Returns a URL for the `get_activity` API command.
  String getActivityUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
  });

  /// Returns a URL for the `pms_image_proxy` API command.
  String pmsImageProxyUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    String img,
    int ratingKey,
    int height,
    int opacity,
    int background,
    int blur,
    String fallback,
  });

  /// Returns a URL for the `get_geo_ip_lookup` API command.
  String getGeoIpLookupUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    @required String ipAddress,
  });

  /// Returns a URL for the `get_activity` API command.
  String terminateSessionUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    @required int sessionKey,
    String message,
  });

  /// Returns a URL for the `register_device` API command.
  String registerDevice({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    @required String deviceId,
    @required String deviceName,
    @required String onesignalId,
  });

  /// Returns a map for use as a request header for use with basic auth.
  Map<String, String> buildBasicAuthHeader({
    @required String user,
    @required String password,
  });
}

class TautulliApiUrlsImpl implements TautulliApiUrls {
  final GetSettings getSettings;

  TautulliApiUrlsImpl({@required this.getSettings});

  @override
  String getActivityUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
  }) {
    if ((protocol == null || domain == null || deviceToken == null)) {
      throw SettingsException();
    }

    final completeUrl =
        '$protocol://$domain/api/v2?apikey=$deviceToken&cmd=get_activity&app=true';

    return completeUrl;
  }

  @override
  String pmsImageProxyUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    String img = '',
    int ratingKey,
    int height = 300,
    int opacity,
    int background,
    int blur,
    String fallback,
  }) {
    if ((protocol == null || domain == null || deviceToken == null)) {
      throw SettingsException();
    }

    final String completeUrl =
        '$protocol://$domain/api/v2?apikey=$deviceToken&cmd=pms_image_proxy&app=true&img=$img&rating_key=$ratingKey&height=$height&opacity=$opacity&background=$background&blur=$blur&fallback=$fallback';

    return completeUrl;
  }

  @override
  String getGeoIpLookupUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    @required String ipAddress,
  }) {
    if ((protocol == null || domain == null || deviceToken == null)) {
      throw SettingsException();
    }
    final String completeUrl =
        '$protocol://$domain/api/v2?apikey=$deviceToken&cmd=get_geoip_lookup&app=true&ip_address=$ipAddress';

    return completeUrl;
  }

  @override
  String terminateSessionUrl({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    @required int sessionKey,
    String message,
  }) {
    String completeUrl;

    if ((protocol == null || domain == null || deviceToken == null)) {
      throw SettingsException();
    }
    if (isNotBlank(message)) {
      completeUrl =
          '$protocol://$domain/api/v2?apikey=$deviceToken&cmd=terminate_session&app=true&session_key=$sessionKey&message=$message';
    } else {
      completeUrl =
          '$protocol://$domain/api/v2?apikey=$deviceToken&cmd=terminate_session&app=true&session_key=$sessionKey';
    }

    return completeUrl;
  }

  @override
  String registerDevice({
    @required String protocol,
    @required String domain,
    @required String deviceToken,
    @required String deviceId,
    @required String deviceName,
    @required String onesignalId,
  }) {
    final String completeUrl =
        '$protocol://$domain/api/v2?apikey=$deviceToken&cmd=register_device&app=true&device_id=$deviceId&device_name=$deviceName&onesignal_id=$onesignalId';
    return completeUrl;
  }

  @override
  Map<String, String> buildBasicAuthHeader({
    @required String user,
    @required String password,
  }) {
    Map<String, String> headers = {};

    if (user != null && password != null) {
      headers['authorization'] = 'Basic ' +
          base64Encode(
            utf8.encode('$user:$password'),
          );
      return headers;
    }
    return headers;
  }
}
