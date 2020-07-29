import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_message_helper.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/activity.dart';
import '../../domain/usecases/get_activity.dart';
import '../../domain/usecases/get_geo_ip.dart';

part 'activity_event.dart';
part 'activity_state.dart';

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
          message: FailureMessageHelper().mapFailureToMessage(failure),
          suggestion: FailureMessageHelper().mapFailureToSuggestion(failure),
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
}
