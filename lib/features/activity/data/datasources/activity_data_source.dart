import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../domain/entities/activity.dart';
import '../models/activity_model.dart';

abstract class ActivityDataSource {
  /// Returns a map containing activity data with the stored `plexName` for a key.
  ///
  /// This key has a map with a key of  `result` with a value of `'success'` or `'failure'`
  /// and either an `activity` or `failure` key based on the `result` value.
  ///
  /// `activity` is a list of [ActivityItem] and `failure` will contain a [Failure].
  ///
  /// Throws a [MissingServerException] if no servers are configured.
  ///
  /// Throws a [TimeoutException] if a connectionAddress takes too long to repsond.
  ///
  /// If there is only one server:
  /// Throws a [SettingsException] if the [primarConnectionAddress]
  /// or [deviceToken] are null.Throws a [ServerException] if the
  /// server responds with a [StatusCode] other than 200.
  ///
  /// If there are multiple servers:
  /// Stores the corresponding [Failure] under the `failure` key.
  Future<Map<String, Map<String, Object>>> getActivity();
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final http.Client client;
  final Settings settings;
  final TautulliApiUrls tautulliApiUrls;
  final Logging logging;

  ActivityDataSourceImpl({
    @required this.client,
    @required this.settings,
    @required this.tautulliApiUrls,
    @required this.logging,
  });

  @override
  Future<Map<String, Map<String, Object>>> getActivity() async {
    final serverList = await settings.getAllServers();

    if (serverList.isEmpty) {
      throw MissingServerException();
    }

    Map<String, Map<String, Object>> activityMap = {};

    for (var server in serverList) {
      if (isEmpty(server.primaryConnectionAddress) ||
          isEmpty(server.deviceToken)) {
        // If primary connection or device token missing
        // Throw SettingsException for single server
        // Put SettingsFailure in map for multiserver
        if (serverList.length <= 1) {
          throw SettingsException();
        } else {
          activityMap[server.plexName] = {
            'result': 'failure',
            'failure': SettingsFailure(),
          };
          break;
        }
      }

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      http.Response response;

      //* Try to connect to primary connection address
      try {
        if (isNotEmpty(server.primaryConnectionUser) &&
            isNotEmpty(server.primaryConnectionPassword)) {
          headers['authorization'] = 'Basic ' +
              base64Encode(
                utf8.encode(
                    '${server.primaryConnectionUser}:${server.primaryConnectionPassword}'),
              );
        }

        response = await client
            .get(
              tautulliApiUrls.getActivityUrl(
                protocol: server.primaryConnectionProtocol,
                domain: server.primaryConnectionDomain,
                deviceToken: server.deviceToken,
              ),
              headers: headers,
            )
            .timeout(
              Duration(seconds: 3),
            );

        if (response.statusCode != 200) {
          throw ServerException;
        }
      } catch (error) {
        logging.error(
            'Activity: Primary connection failed with [${error.runtimeType}].');
        //* If secondary connection address exists try to connect to it
        if (isNotEmpty(server.secondaryConnectionAddress)) {
          try {
            if (isNotEmpty(server.secondaryConnectionUser) &&
                isNotEmpty(server.secondaryConnectionPassword)) {
              headers['authorization'] = 'Basic ' +
                  base64Encode(
                    utf8.encode(
                        '${server.secondaryConnectionUser}:${server.secondaryConnectionPassword}'),
                  );
            }

            response = await client
                .get(
                  tautulliApiUrls.getActivityUrl(
                    protocol: server.secondaryConnectionProtocol,
                    domain: server.secondaryConnectionDomain,
                    deviceToken: server.deviceToken,
                  ),
                  headers: headers,
                )
                .timeout(
                  Duration(seconds: 3),
                );

            if (response.statusCode != 200) {
              throw ServerException;
            }
          } catch (error) {
            logging.error(
                'Activity: Secondary connection failed with [${error.runtimeType}].');
            // Re-throw error for single server
            if (serverList.length <= 1) {
              throw error;
            }

            // Store related failure in map for multiserver
            activityMap[server.plexName] = {
              'result': 'failure',
              'failure': _mapErrorToFailure(error),
            };
            break;
          }
        } else {
          // Re-throw error for single server
          if (serverList.length <= 1) {
            throw error;
          }

          // Store related failure in map for multiserver
          activityMap[server.plexName] = {
            'result': 'failure',
            'failure': _mapErrorToFailure(error),
          };
          break;
        }
      }

      //* Build activityList
      final responseJson = json.decode(response.body);
      final List<ActivityItem> activityList = [];
      responseJson['response']['data']['sessions'].forEach(
        (session) {
          activityList.add(
            ActivityItemModel.fromJson(session),
          );
        },
      );

      //* Build activityMap using activityList
      activityMap[server.plexName] = {
        'result': 'success',
        'activity': activityList,
      };
    }

    return activityMap;
  }
}

Failure _mapErrorToFailure(dynamic error) {
  switch (error.runtimeType) {
    case (SocketException):
      return SocketFailure();
    case (HandshakeException):
      return TlsFailure();
    case (FormatException):
      return UrlFormatFailure();
    case (ArgumentError):
      return UrlFormatFailure();
    default:
      return UnknownFailure();
  }
}
