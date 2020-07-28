import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/activity.dart';
import '../../domain/usecases/get_activity.dart';
import '../../domain/usecases/get_geo_ip.dart';

part 'activity_event.dart';
part 'activity_state.dart';

// Error messages
const String MISSING_SERVER_FAILURE_MESSAGE = 'No servers are configured.';
const String SERVER_FAILURE_MESSAGE = 'Failed to connect to server.';
const String CONNECTION_FAILURE_MESSAGE = 'No network connectivity.';
const String SETTINGS_FAILURE_MESSAGE = 'Required settings are missing.';
const String SOCKET_FAILURE_MESSAGE =
    'Failed to connect to Connection Address.';
const String TLS_FAILURE_MESSAGE = 'Failed to establish TLS/SSL connection.';
const String URL_FORMAT_FAILURE_MESSAGE = 'Incorrect URL format.';
const String TIMEOUT_FAILURE_MESSAGE = 'Connection to server timed out.';

// Error suggestions
const String MISSING_SERVER_SUGGESTION =
    'Please register with a Tautulli server.';
const String CHECK_CONNECTION_ADDRESS_SUGGESTION =
    'Check your Connection Address for errors.';
const String CHECK_SERVER_SETTINGS_SUGGESTION =
    'Please verify your connection settings.';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetActivity getActivity;
  final GetGeoIp getGeoIp;
  final TautulliApiUrls tautulliApiUrls;
  final Logging logging;

  ActivityBloc({
    @required GetActivity activity,
    @required GetGeoIp geoIp,
    @required this.tautulliApiUrls,
    @required this.logging,
  })  : assert(activity != null),
        assert(geoIp != null),
        getActivity = activity,
        getGeoIp = geoIp,
        super(ActivityEmpty());

  @override
  Stream<ActivityState> mapEventToState(
    ActivityEvent event,
  ) async* {
    if (event is ActivityLoad) {
      //TODO: Change to debug
      logging.info('Activity: Attempting to load activity');
      yield ActivityLoadInProgress();
      yield* _loadActivityOrFailure();
    }
    if (event is ActivityRefresh) {
      logging.info('Activity: Attempting to load activity');
      yield* _loadActivityOrFailure();
    }
  }

  Stream<ActivityState> _loadActivityOrFailure() async* {
    final failureOrActivity = await getActivity();
    yield* failureOrActivity.fold(
      (failure) async* {
        logging.error('Activity: Failed to load activity [$failure]');
        yield ActivityLoadFailure(
          failure: failure,
          message: _mapFailureToMessage(failure),
          suggestion: _mapFailureToSuggestion(failure),
        );
      },
      (activityMap) async* {
        final Map<String, dynamic> geoIpMap = {};

        //TODO: Change to debug
        logging
            .info('Activity: Attempting to load activity Geo IP information');

        // Using for loop as .forEach() does not actually respect await
        final List keys = activityMap.keys.toList();
        for (int i = 0; i < keys.length; i++) {
          if (activityMap[keys[i]]['result'] == 'success') {
            for (ActivityItem activityItem in activityMap[keys[i]]
                ['activity']) {
              final failureOrGeoIp = await getGeoIp(
                tautulliId: keys[i],
                ipAddress: activityItem.ipAddress,
              );

              failureOrGeoIp.fold(
                (failure) {
                  logging.warning(
                      'Activit: Failed to load GeoIP data for ${activityItem.ipAddress}');
                  return null;
                },
                (geoIpItem) {
                  geoIpMap[activityItem.ipAddress] = geoIpItem;
                },
              );
            }
          }
        }

        logging.info('Activity: Activity loaded successfully');

        yield ActivityLoadSuccess(
          activityMap: activityMap,
          geoIpMap: geoIpMap,
          tautulliApiUrls: tautulliApiUrls,
          loadedAt: DateTime.now(),
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case MissingServerFailure:
        return MISSING_SERVER_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case ConnectionFailure:
        return CONNECTION_FAILURE_MESSAGE;
      case SettingsFailure:
        return SETTINGS_FAILURE_MESSAGE;
      case SocketFailure:
        return SOCKET_FAILURE_MESSAGE;
      case TlsFailure:
        return TLS_FAILURE_MESSAGE;
      case UrlFormatFailure:
        return URL_FORMAT_FAILURE_MESSAGE;
      case TimeoutFailure:
        return TIMEOUT_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  String _mapFailureToSuggestion(Failure failure) {
    switch (failure.runtimeType) {
      case MissingServerFailure:
        return MISSING_SERVER_SUGGESTION;
      case ServerFailure:
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case SettingsFailure:
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case SocketFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TlsFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case UrlFormatFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TimeoutFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      default:
        return '';
    }
  }
}
