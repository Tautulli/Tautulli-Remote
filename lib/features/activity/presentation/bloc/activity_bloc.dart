import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../domain/entities/activity.dart';
import '../../domain/usecases/get_activity.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetActivity getActivity;
  final GetImageUrl getImageUrl;
  final Settings settings;
  final Logging logging;

  Timer _timer;

  ActivityBloc({
    @required GetActivity activity,
    @required GetImageUrl imageUrl,
    @required this.settings,
    @required this.logging,
  })  : assert(activity != null),
        getActivity = activity,
        getImageUrl = imageUrl,
        super(ActivityEmpty());

  @override
  Stream<ActivityState> mapEventToState(
    ActivityEvent event,
  ) async* {
    if (event is ActivityLoad) {
      yield* _mapActivityLoadToState();
    }
    if (event is ActivityRefresh) {
      yield* _mapActivityRefreshToState();
    }
    if (event is ActivityAutoRefreshStart) {
      yield* _mapActivityAutoRefreshStartToState();
    }
    if (event is ActivityAutoRefreshStop) {
      yield* _mapActivityAutoRefreshStopToState();
    }
    if (event is ActivityRemove) {
      yield* _mapActivityRemoveToState(
        event.activityMap,
        event.sessionId,
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Stream<ActivityState> _mapActivityLoadToState() async* {
    yield ActivityLoadInProgress();
    yield* _loadActivityOrFailure();

    add(ActivityAutoRefreshStart());
  }

  Stream<ActivityState> _mapActivityRefreshToState() async* {
    yield* _loadActivityOrFailure();

    add(ActivityAutoRefreshStart());
  }

  Stream<ActivityState> _mapActivityAutoRefreshStartToState() async* {
    _timer?.cancel();
    final refreshRate = await settings.getRefreshRate();
    if (refreshRate != null && refreshRate > 0) {
      _timer = Timer.periodic(Duration(seconds: refreshRate), (timer) {
        add(ActivityRefresh());
      });
    }
  }

  Stream<ActivityState> _mapActivityAutoRefreshStopToState() async* {
    _timer?.cancel();
  }

  Stream<ActivityState> _mapActivityRemoveToState(
    Map<String, Map<String, Object>> activityMap,
    String sessionId,
  ) async* {
    // Create a new Map that can be manipulated
    Map<String, Map<String, Object>> newActivityMap =
        Map<String, Map<String, Object>>.from(activityMap);

    // Remove the item from the map where the key is the submitted
    // tautulliId and the value has the submitted sessionKey
    newActivityMap.forEach((key, value) {
      List activityList = value['activity'];
      activityList
          .removeWhere((activityItem) => activityItem.sessionId == sessionId);
    });

    // Return activity with the map sans the removed item
    yield ActivityLoadSuccess(
      activityMap: newActivityMap,
      loadedAt: DateTime.now(),
    );
  }

  Stream<ActivityState> _loadActivityOrFailure() async* {
    final failureOrActivity = await getActivity();
    yield* failureOrActivity.fold(
      (failure) async* {
        logging.error('Activity: Failed to load activity [$failure]');
        yield ActivityLoadFailure(
          failure: failure,
          message: FailureMapperHelper().mapFailureToMessage(failure),
          suggestion: FailureMapperHelper().mapFailureToSuggestion(failure),
        );
      },
      (activityMap) async* {
        //* Loop through activity items and get image URLs
        // Using for loop as .forEach() does not actually respect await
        final List keys = activityMap.keys.toList();
        for (int i = 0; i < keys.length; i++) {
          if (activityMap[keys[i]]['result'] == 'success') {
            for (ActivityItem activityItem in activityMap[keys[i]]
                ['activity']) {
              //* Fetch and assign image URLs
              String posterImg;
              int posterRatingKey;
              String posterFallback;

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
                  posterImg = activityItem.thumb;
                  posterRatingKey = activityItem.ratingKey;
                  posterFallback = 'poster';
                  break;
                default:
                  posterRatingKey = activityItem.ratingKey;
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
                  logging.warning(
                      'Activity: Failed to load poster for rating key: $posterRatingKey');
                },
                (url) {
                  activityItem.posterUrl = url;
                },
              );
            }
          }
        }

        yield ActivityLoadSuccess(
          activityMap: activityMap,
          loadedAt: DateTime.now(),
        );
      },
    );
  }
}
