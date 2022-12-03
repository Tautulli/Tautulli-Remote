import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/location.dart';
import '../../../../core/types/stream_decision.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/server_activity_model.dart';
import '../../domain/usecases/activity.dart';

part 'activity_event.dart';
part 'activity_state.dart';

// Map<String, List<ActivityModel>> activityCache = {};
List<ServerActivityModel> serverActivityListCache = [];
String? tautulliIdCache;

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final Activity activity;
  final ImageUrl imageUrl;
  final Logging logging;

  ActivityBloc({
    required this.activity,
    required this.imageUrl,
    required this.logging,
  }) : super(
          ActivityState(
            serverActivityList: serverActivityListCache,
          ),
        ) {
    on<ActivityFetched>(_onActivityFetched);
  }

  Future<void> _onActivityFetched(
    ActivityFetched event,
    Emitter<ActivityState> emit,
  ) async {
    final bool serverChange = tautulliIdCache != event.tautulliId;

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          serverActivityList: serverChange ? [] : null,
        ),
      );

      serverActivityListCache = [];
    }

    tautulliIdCache = event.tautulliId;

    final settingsState = event.settingsBloc.state as SettingsSuccess;

    final server = settingsState.appSettings.activeServer;
    final tautulliId = server.tautulliId;

    tautulliIdCache = tautulliId;

    final failureOrActivity = await activity.getActivity(
      tautulliId: tautulliId,
      // sessionKey: event.sessionKey,
      // sessionId: event.sessionId,
    );

    await failureOrActivity.fold(
      (failure) async {
        logging.error('Activity :: Failed to fetch activity for ${event.tautulliId} [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (activity) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.tautulliId,
            primaryActive: activity.value2,
          ),
        );

        // Add posters to activity models
        List<ActivityModel> activityListWithUris = await _activityModelsWithPosterUris(
          activityList: activity.value1,
          settingsBloc: event.settingsBloc,
        );

        // activityCache[tautulliId] = activityListWithUris;
        final serverCacheIndex = serverActivityListCache.indexWhere((server) => server.tautulliId == tautulliId);

        if (serverCacheIndex > -1) {
          serverActivityListCache[serverCacheIndex] = serverActivityListCache[serverCacheIndex].copyWith(
            activityList: activityListWithUris,
          );
        } else {
          int copyCount = 0;
          int directPlayCount = 0;
          int transcodeCount = 0;
          int lanBandwidth = 0;
          int wanBandwidth = 0;

          for (int i = 0; i < activityListWithUris.length; i++) {
            if (activityListWithUris[i].transcodeDecision == StreamDecision.directPlay) directPlayCount += 1;
            if (activityListWithUris[i].transcodeDecision == StreamDecision.copy) copyCount += 1;
            if (activityListWithUris[i].transcodeDecision == StreamDecision.transcode) transcodeCount += 1;

            if (activityListWithUris[i].bandwidth != null) {
              if (activityListWithUris[i].location == Location.lan) {
                lanBandwidth += activityListWithUris[i].bandwidth!;
              } else {
                wanBandwidth += activityListWithUris[i].bandwidth!;
              }
            }
          }

          serverActivityListCache.add(
            ServerActivityModel(
              sortIndex: server.sortIndex,
              serverName: server.plexName,
              tautulliId: tautulliId,
              activityList: activityListWithUris,
              copyCount: copyCount,
              directPlayCount: directPlayCount,
              transcodeCount: transcodeCount,
              lanBandwidth: lanBandwidth,
              wanBandwidth: wanBandwidth,
            ),
          );
        }

        serverActivityListCache.sort(
          (a, b) => a.sortIndex.compareTo(b.sortIndex),
        );

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            serverActivityList: serverActivityListCache,
          ),
        );
      },
    );
  }

  Future<List<ActivityModel>> _activityModelsWithPosterUris({
    required List<ActivityModel> activityList,
    required SettingsBloc settingsBloc,
  }) async {
    List<ActivityModel> activityWithImages = [];

    for (ActivityModel activity in activityList) {
      Uri? imageUri;
      Uri? parentImageUri;
      Uri? grandparentImageUri;

      if (activity.thumb != null || activity.ratingKey != null) {
        final failureOrImageUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliIdCache!,
          img: activity.thumb,
          ratingKey: activity.ratingKey,
        );

        await failureOrImageUrl.fold(
          (failure) async {
            logging.error(
              'Activity :: Failed to fetch image url for ${activity.title} [$failure]',
            );
          },
          (imageUriTuple) async {
            settingsBloc.add(
              SettingsUpdatePrimaryActive(
                tautulliId: tautulliIdCache!,
                primaryActive: imageUriTuple.value2,
              ),
            );

            imageUri = imageUriTuple.value1;
          },
        );
      }

      if (activity.parentThumb != null || activity.parentRatingKey != null) {
        final failureOrParentImageUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliIdCache!,
          img: activity.parentThumb,
          ratingKey: activity.parentRatingKey,
        );

        await failureOrParentImageUrl.fold(
          (failure) async {
            logging.error(
              'Activity :: Failed to fetch parent image url for ${activity.title} [$failure]',
            );
          },
          (imageUriTuple) async {
            settingsBloc.add(
              SettingsUpdatePrimaryActive(
                tautulliId: tautulliIdCache!,
                primaryActive: imageUriTuple.value2,
              ),
            );

            parentImageUri = imageUriTuple.value1;
          },
        );
      }

      if (activity.grandparentThumb != null || activity.grandparentRatingKey != null) {
        final failureOrGrandparentImageUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliIdCache!,
          img: activity.grandparentThumb,
          ratingKey: activity.grandparentRatingKey,
        );

        await failureOrGrandparentImageUrl.fold(
          (failure) async {
            logging.error(
              'Activity :: Failed to fetch grandparent image url for ${activity.title} [$failure]',
            );
          },
          (imageUriTuple) async {
            settingsBloc.add(
              SettingsUpdatePrimaryActive(
                tautulliId: tautulliIdCache!,
                primaryActive: imageUriTuple.value2,
              ),
            );

            grandparentImageUri = imageUriTuple.value1;
          },
        );
      }

      activityWithImages.add(
        activity.copyWith(
          imageUri: imageUri,
          parentImageUri: parentImageUri,
          grandparentImageUri: grandparentImageUri,
        ),
      );
    }

    return activityWithImages;
  }
}
