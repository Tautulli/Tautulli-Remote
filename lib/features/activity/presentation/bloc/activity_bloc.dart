import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_message_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/activity.dart';
import '../../domain/usecases/get_activity.dart';
import '../../domain/usecases/get_geo_ip.dart';
import '../../domain/usecases/get_image_url.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetActivity getActivity;
  final GetGeoIp getGeoIp;
  final GetImageUrl getImageUrl;
  final TautulliApi tautulliApi;
  final Logging logging;

  ActivityBloc({
    @required GetActivity activity,
    @required GetGeoIp geoIp,
    @required GetImageUrl imageUrl,
    @required this.tautulliApi,
    @required this.logging,
  })  : assert(activity != null),
        assert(geoIp != null),
        getActivity = activity,
        getGeoIp = geoIp,
        getImageUrl = imageUrl,
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
    if (event is ActivityRemove) {
      // Create a new Map that can be manipulated
      Map<String, Map<String, Object>> newActivityMap =
          Map<String, Map<String, Object>>.from(event.activityMap);

      // Remove the item from the map where the key is the submitted
      // tautulliId and the value has the submitted sessionKey
      newActivityMap.forEach((key, value) {
        // if (key == event.tautulliId) {
          List activityList = value['activity'];
          activityList.removeWhere(
              (activityItem) => activityItem.sessionId == event.sessionId);
        // }
      });

      // Return activity with the map sans the removed item
      yield ActivityLoadSuccess(
        activityMap: newActivityMap,
        loadedAt: DateTime.now(),
      );
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
        //TODO: Change to debug
        logging
            .info('Activity: Attempting to load activity Geo IP information');

        //* Loop through activity items and get geoIP data and image URLs
        // Using for loop as .forEach() does not actually respect await
        final List keys = activityMap.keys.toList();
        for (int i = 0; i < keys.length; i++) {
          if (activityMap[keys[i]]['result'] == 'success') {
            for (ActivityItem activityItem in activityMap[keys[i]]
                ['activity']) {
              //* Fetch GeoIP data for activity items
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
                  activityItem.geoIpItem = geoIpItem;
                },
              );

              //* Fetch and assign image URLs
              String posterImg;
              int posterRatingKey;
              String posterFallback;
              String backgroundImg;

              // Assign values for poster URL
              switch (activityItem.mediaType) {
                case ('movie'):
                  posterImg = activityItem.thumb;
                  posterRatingKey = activityItem.ratingKey;
                  if (activityItem.live == 0) {
                    posterFallback = 'poster';
                  } else {
                    posterFallback = 'poster-live';
                  }
                  break;
                case ('episode'):
                  posterImg = activityItem.grandparentThumb;
                  posterRatingKey = activityItem.grandparentRatingKey;
                  if (activityItem.live == 0) {
                    posterFallback = 'poster';
                  } else {
                    posterFallback = 'poster-live';
                  }
                  break;
                case ('track'):
                  posterImg = activityItem.thumb;
                  posterRatingKey = activityItem.parentRatingKey;
                  posterFallback = 'cover';
                  break;
                case ('clip'):
                  posterImg = activityItem.art.replaceFirst('/art', '/thumb');
                  posterRatingKey = activityItem.ratingKey;
                  posterFallback = 'poster';
                  break;
                default:
                  posterRatingKey = activityItem.ratingKey;
              }

              // Assign values for background URL
              switch (activityItem.mediaType) {
                case ('photo'):
                  backgroundImg = activityItem.thumb;
                  break;
                default:
                  backgroundImg = activityItem.art;
              }

              // Attempt to get poster URL
              final failureOrPosterUrl = await getImageUrl(
                tautulliId: keys[i],
                img: posterImg,
                ratingKey: posterRatingKey,
                fallback: posterFallback,
              );
              failureOrPosterUrl.fold(
                (failure) {
                  //TODO: Log failure?
                  return null;
                },
                (url) {
                  activityItem.posterUrl = url;
                },
              );

              // Attempt to get poster background URL if track
              if (activityItem.mediaType == 'track') {
                final failureOrPosterBackgroundUrl = await getImageUrl(
                  tautulliId: keys[i],
                  img: posterImg,
                  ratingKey: posterRatingKey,
                  opacity: 40,
                  background: 282828,
                  blur: 15,
                  fallback: 'poster',
                );
                failureOrPosterBackgroundUrl.fold(
                  (failure) {
                    //TODO: Log failure?
                    return null;
                  },
                  (url) {
                    activityItem.posterBackgroundUrl = url;
                  },
                );
              }

              // Attempt to get background art URL
              final failureOrBackgroundUrl = await getImageUrl(
                tautulliId: keys[i],
                img: backgroundImg,
                ratingKey: activityItem.ratingKey,
                fallback: 'art',
              );
              failureOrBackgroundUrl.fold(
                (failure) {
                  //TODO: Log failure?
                  return null;
                },
                (url) {
                  activityItem.backgroundUrl = url;
                },
              );
            }
          }
        }

        logging.info('Activity: Activity loaded successfully');

        yield ActivityLoadSuccess(
          activityMap: activityMap,
          loadedAt: DateTime.now(),
        );
      },
    );
  }
}
