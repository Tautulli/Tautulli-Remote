import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../domain/entities/activity.dart';
import '../models/activity_model.dart';

abstract class ActivityDataSource {
  /// Returns a map containing activity data with the stored `tautulliId` for a key.
  ///
  /// This key has a map with a key of `plex_name` with the server name, `result` with
  /// a value of `'success'` or `'failure'` and either an `activity` or `failure` key
  /// based on the `result` value.
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
  final TautulliApi tautulliApi;
  final Logging logging;

  ActivityDataSourceImpl({
    @required this.client,
    @required this.settings,
    @required this.tautulliApi,
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
      if (isEmpty(server.tautulliId) || isEmpty(server.plexName)) {
        if (serverList.length <= 1) {
          throw SettingsException();
        } else {
          //TODO: Add logging?
          break;
        }
      }

      if (isEmpty(server.primaryConnectionAddress) ||
          isEmpty(server.deviceToken)) {
        // If primary connection or device token missing
        // Throw SettingsException for single server
        // Put SettingsFailure in map for multiserver
        if (serverList.length <= 1) {
          throw SettingsException();
        } else {
          activityMap[server.tautulliId] = {
            'plex_name': server.plexName,
            'result': 'failure',
            'failure': SettingsFailure(),
          };
        }
      }

      try {
        //* Build activityList
        final activityJson = await tautulliApi.getActivity(server.tautulliId);
        final List<ActivityItem> activityList = [];
        activityJson['response']['data']['sessions'].forEach(
          (session) {
            activityList.add(
              ActivityItemModel.fromJson(session),
            );
          },
        );

        //* Build activityMap using activityList
        activityMap[server.tautulliId] = {
          'plex_name': server.plexName,
          'result': 'success',
          'activity': activityList,
        };
      } catch (error) {
        if (serverList.length <= 1) {
          throw error;
        } else {
          activityMap[server.tautulliId] = {
            'plex_name': server.plexName,
            'result': 'failure',
            'failure': _mapErrorToFailure(error),
          };
        }
      }
    }
    return activityMap;
  }
}

Failure _mapErrorToFailure(dynamic error) {
  switch (error.runtimeType) {
    case (ServerException):
      return ServerFailure();
    case (SocketException):
      return SocketFailure();
    case (HandshakeException):
      return TlsFailure();
    case (FormatException):
      return UrlFormatFailure();
    case (ArgumentError):
      return UrlFormatFailure();
    case (TimeoutException):
      return TimeoutFailure();
    case (JsonDecodeException):
      return JsonDecodeFailure();
    default:
      return UnknownFailure();
  }
}
