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
const String SERVER_FAILURE_MESSAGE = 'Failed to connect to server.';
const String CONNECTION_FAILURE_MESSAGE = 'No network connectivity.';
const String SETTINGS_FAILURE_MESSAGE = 'Required settings are missing.';
const String SOCKET_FAILURE_MESSAGE =
    'Failed to connect to Connection Address.';
const String TLS_FAILURE_MESSAGE = 'Failed to establish TLS/SSL connection.';
const String URL_FORMAT_FAILURE_MESSAGE = 'Incorrect URL format.';

// Error suggestions
const String CHECK_CONNECTION_ADDRESS_SUGGESTION =
    'Check your Connection Address for errors.';
const String CHECK_SERVER_SETTINGS_SUGGESTION =
    'Please register with a Tautulli server.';

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
      //TODO: Change to dubug
      logging.info('Activity: Attempting to load activity');
      yield ActivityLoadInProgress();
      yield* _loadActivityOrFailure();
    }
    if (event is ActivityRefresh) {
      print('refreshing activity');
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
      (activity) async* {
        final Map<String, dynamic> geoIpMap = {};

        //TODO: Change to dubug
        logging.info(
            'Activity: Attempting to load activity Geo IP information');

        for (ActivityItem activityItem in activity) {
          final failureOrGeoIp = await getGeoIp(activityItem.ipAddress);

          failureOrGeoIp.fold(
            (failure) {
              logging.warning(
                  'Activit: Failed to load Geo IP data for ${activityItem.ipAddress}');
              print('failure');
              return null;
            },
            (geoIpItem) {
              geoIpMap[activityItem.ipAddress] = geoIpItem;
            },
          );
        }

        logging.info('Activity: Activity loaded successfully');

        yield ActivityLoadSuccess(
          activity: activity,
          geoIpMap: geoIpMap,
          tautulliApiUrls: tautulliApiUrls,
          loadedAt: DateTime.now(),
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
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
      default:
        return 'Unexpected error';
    }
  }

  String _mapFailureToSuggestion(Failure failure) {
    switch (failure.runtimeType) {
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
      default:
        return '';
    }
  }
}
