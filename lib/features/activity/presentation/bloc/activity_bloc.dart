import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../domain/entities/activity.dart';
import '../../domain/usecases/get_activity.dart';

part 'activity_event.dart';
part 'activity_state.dart';

enum ActivityLoadingState {
  initial,
  inProgress,
  success,
  failure,
}

Map<String, Map<String, dynamic>> _activityMap = {};

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
        super(ActivityInitial(
          activityMap: _activityMap,
        ));

  @override
  Stream<ActivityState> mapEventToState(
    ActivityEvent event,
  ) async* {
    final currentState = state;
    final serverList = await settings.getAllServers();

    if (currentState is ActivityLoaded) {
      _activityMap = currentState.activityMap;
    }

    // If configured server is not in _activityMap then add it
    for (ServerModel server in serverList) {
      if (!_activityMap.containsKey(server.tautulliId)) {
        _activityMap[server.tautulliId] = {
          'plex_name': server.plexName,
          'loadingState': ActivityLoadingState.initial,
          'activityList': <ActivityItem>[],
          'failure': null,
        };
      }
    }

    // Remove servers from _activityMap that are no longer configured
    List toRemove = [];
    for (String tautulliId in _activityMap.keys) {
      int item =
          serverList.indexWhere((server) => server.tautulliId == tautulliId);
      if (item == -1) {
        toRemove.add(tautulliId);
      }
    }
    _activityMap.removeWhere((key, value) => toRemove.contains(key));

    if (event is ActivityLoadAndRefresh) {
      if (serverList.length > 0) {
        // Do not refresh servers that are still in the process of loading
        serverList.removeWhere((server) =>
            _activityMap[server.tautulliId]['loadingState'] ==
            ActivityLoadingState.inProgress);

        for (String key in _activityMap.keys.toList()) {
          _activityMap[key]['loadingState'] = ActivityLoadingState.inProgress;
        }
        yield ActivityLoaded(
          activityMap: _activityMap,
          loadedAt: DateTime.now(),
        );
        _loadServer(
          serverList: serverList,
          activityMap: _activityMap,
        );
      } else {
        yield ActivityLoadFailure(
          failure: MissingServerFailure(),
          message:
              FailureMapperHelper.mapFailureToMessage(MissingServerFailure()),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(
              MissingServerFailure()),
        );
      }
    }
    if (event is ActivityLoadServer) {
      yield* event.failureOrActivity.fold(
        (failure) async* {
          logging.error(
            'Activity: Failed to load activity for ${event.plexName}. ${FailureMapperHelper.mapFailureToMessage(failure)}',
          );

          _activityMap[event.tautulliId] = {
            'plex_name': event.plexName,
            'loadingState': ActivityLoadingState.failure,
            'activityList': <ActivityItem>[],
            'failure': failure,
          };

          yield ActivityLoaded(
            activityMap: _activityMap,
            loadedAt: DateTime.now(),
          );
        },
        (list) async* {
          for (ActivityItem activityItem in list) {
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
              tautulliId: event.tautulliId,
              img: posterImg,
              ratingKey: posterRatingKey,
              fallback: posterFallback,
            );
            failureOrPosterUrl.fold(
              (failure) {
                logging.warning(
                  'Activity: Failed to load poster for rating key $posterRatingKey',
                );
              },
              (url) {
                activityItem.posterUrl = url;
              },
            );
          }
          _activityMap[event.tautulliId] = {
            'plex_name': event.plexName,
            'loadingState': ActivityLoadingState.success,
            'activityList': list,
            'failure': null,
          };
          yield ActivityLoaded(
            activityMap: _activityMap,
            loadedAt: DateTime.now(),
          );
        },
      );
      add(ActivityAutoRefreshStart());
    }
    if (event is ActivityAutoRefreshStart) {
      _timer?.cancel();
      final refreshRate = await settings.getRefreshRate();
      if (refreshRate != null && refreshRate > 0) {
        _timer = Timer.periodic(Duration(seconds: refreshRate), (timer) {
          add(ActivityLoadAndRefresh());
        });
      }
    }
    if (event is ActivityAutoRefreshStop) {
      _timer?.cancel();
    }
  }

  /// For each server in serverList add the [ActivityLoadServer] event with the current activityMap.
  ///
  /// This will allow for asynchronous loading of each server and will yield [ActivityLoaded] with the
  /// servers data added to the activityMap.
  void _loadServer({
    @required List<ServerModel> serverList,
    @required Map<String, Map<String, dynamic>> activityMap,
  }) {
    for (ServerModel server in serverList) {
      getActivity(tautulliId: server.tautulliId).then(
        (failureOrActivity) => add(
          ActivityLoadServer(
            tautulliId: server.tautulliId,
            plexName: server.plexName,
            failureOrActivity: failureOrActivity,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
