import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/location.dart';
import '../../../../core/types/stream_decision.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/server_activity_model.dart';
import '../../domain/usecases/activity.dart';

part 'activity_event.dart';
part 'activity_state.dart';

List<ServerActivityModel> serverActivityListCache = [];
late List<ServerModel> serverListCache;
late bool multiserverCache;
String? activeServerIdCache;
late SettingsBloc settingsBlocCache;

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final Activity activity;
  final ImageUrl imageUrl;
  final Logging logging;
  final Settings settings;

  Timer? _timer;

  ActivityBloc({
    required this.activity,
    required this.imageUrl,
    required this.logging,
    required this.settings,
  }) : super(
          ActivityState(
            serverActivityList: serverActivityListCache,
          ),
        ) {
    on<ActivityFetched>(_onActivityFetched);
    on<ActivityLoadServer>(_onActivityLoadServer);
    on<ActivityAutoRefreshStart>(_onActivityAutoRefreshStart);
    on<ActivityAutoRefreshStop>(_onActivityAutoRefreshStop);
  }

  Future<void> _onActivityFetched(
    ActivityFetched event,
    Emitter<ActivityState> emit,
  ) async {
    if (event.serverList.isNotEmpty) {
      serverListCache = event.serverList;
      multiserverCache = event.multiserver;
      settingsBlocCache = event.settingsBloc;

      _addNewServers(event.serverList);

      _verifyActiveServerId(event.serverList, event.activeServerId);

      _removeOldServers(event.serverList);

      _updateServerSortIndex(event.serverList);

      serverActivityListCache.sort(
        (a, b) => a.sortIndex.compareTo(b.sortIndex),
      );

      emit(
        state.copyWith(
          serverActivityList: [...serverActivityListCache],
        ),
      );

      if (event.multiserver) {
        for (ServerActivityModel serverActivityModel in serverActivityListCache) {
          // Exclude servers already in the process of loading activity
          if (serverActivityModel.status != BlocStatus.inProgress) {
            // Set status to inProgress
            final index = serverActivityListCache.indexWhere((e) => e.tautulliId == serverActivityModel.tautulliId);
            serverActivityListCache[index] = serverActivityModel.copyWith(status: BlocStatus.inProgress);

            emit(
              state.copyWith(
                serverActivityList: [...serverActivityListCache],
              ),
            );

            _loadServer(
              serverActivityModel: serverActivityModel,
              settingsBloc: event.settingsBloc,
            );
          }
        }
      } else {
        final activeServerIndex = serverActivityListCache.indexWhere(
          (server) => server.tautulliId == activeServerIdCache,
        );

        // Update status to inProgress
        serverActivityListCache[activeServerIndex] =
            serverActivityListCache[activeServerIndex].copyWith(status: BlocStatus.inProgress);

        emit(
          state.copyWith(
            serverActivityList: [...serverActivityListCache],
          ),
        );

        _loadServer(
          serverActivityModel: serverActivityListCache[activeServerIndex],
          settingsBloc: event.settingsBloc,
        );
      }
    }

    add(ActivityAutoRefreshStart());
  }

  void _addNewServers(List<ServerModel> serverList) {
    for (ServerModel server in serverList) {
      final bool serverExistsInCache =
          serverActivityListCache.indexWhere((e) => e.tautulliId == server.tautulliId) != -1 ? true : false;

      if (!serverExistsInCache) {
        serverActivityListCache.add(
          ServerActivityModel(
            sortIndex: server.sortIndex,
            serverName: server.plexName,
            tautulliId: server.tautulliId,
            status: BlocStatus.initial,
            activityList: const [],
            copyCount: 0,
            directPlayCount: 0,
            transcodeCount: 0,
            lanBandwidth: 0,
            wanBandwidth: 0,
          ),
        );
      }
    }
  }

  void _verifyActiveServerId(List<ServerModel> serverList, String activeServerId) {
    // Set active server
    final ServerModel activeServer = serverList.firstWhere(
      (server) => server.tautulliId == activeServerId,
    );
    // Set active server if null
    activeServerIdCache ??= activeServer.tautulliId;

    final activeServerIndex = serverActivityListCache.indexWhere(
      (server) => server.tautulliId == activeServer.tautulliId,
    );
    // Clear activityList if active server was changed
    if (activeServerIdCache != activeServer.tautulliId) {
      serverActivityListCache[activeServerIndex] =
          serverActivityListCache[activeServerIndex].copyWith(activityList: []);
    }

    activeServerIdCache = activeServer.tautulliId;
  }

  void _removeOldServers(List<ServerModel> serverList) {
    for (ServerActivityModel serverActivityModel in serverActivityListCache) {
      final bool serverExistsInServerList =
          serverList.indexWhere((server) => server.tautulliId == serverActivityModel.tautulliId) != -1 ? true : false;

      if (!serverExistsInServerList) {
        serverActivityListCache.remove(serverActivityModel);
      }
    }
  }

  void _updateServerSortIndex(List<ServerModel> serverList) {
    for (ServerActivityModel serverActivityModel in serverActivityListCache) {
      final int serverIndex = serverActivityListCache.indexOf(serverActivityModel);
      final int sortIndex =
          serverList.firstWhere((server) => server.tautulliId == serverActivityModel.tautulliId).sortIndex;

      serverActivityListCache[serverIndex] = serverActivityListCache[serverIndex].copyWith(sortIndex: sortIndex);
    }
  }

  void _loadServer({
    required ServerActivityModel serverActivityModel,
    required SettingsBloc settingsBloc,
  }) {
    activity
        .getActivity(
          tautulliId: serverActivityModel.tautulliId,
        )
        .then(
          (failureOrActivity) => add(
            ActivityLoadServer(
              tautulliId: serverActivityModel.tautulliId,
              serverName: serverActivityModel.serverName,
              failureOrActivity: failureOrActivity,
              settingsBloc: settingsBloc,
            ),
          ),
        );
  }

  Future<void> _onActivityLoadServer(
    ActivityLoadServer event,
    Emitter<ActivityState> emit,
  ) async {
    final int index = serverActivityListCache.indexWhere((server) => server.tautulliId == event.tautulliId);

    await event.failureOrActivity.fold(
      (failure) async {
        serverActivityListCache[index] = serverActivityListCache[index].copyWith(
          status: BlocStatus.failure,
          activityList: [],
          failure: failure,
          failureMessage: FailureHelper.mapFailureToMessage(failure),
          failureSuggestion: FailureHelper.mapFailureToSuggestion(failure),
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
          tautulliId: event.tautulliId,
          settingsBloc: event.settingsBloc,
        );

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

        serverActivityListCache[index] = serverActivityListCache[index].copyWith(
          status: BlocStatus.success,
          activityList: activityListWithUris,
          copyCount: copyCount,
          directPlayCount: directPlayCount,
          transcodeCount: transcodeCount,
          lanBandwidth: lanBandwidth,
          wanBandwidth: wanBandwidth,
        );
      },
    );

    emit(
      state.copyWith(
        serverActivityList: [...serverActivityListCache],
      ),
    );
  }

  Future<void> _onActivityAutoRefreshStart(
    ActivityAutoRefreshStart event,
    Emitter<ActivityState> emit,
  ) async {
    _timer?.cancel();

    final refreshRate = await settings.getRefreshRate();

    if (refreshRate > 0 && _timer != null && _timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: refreshRate), (timer) {
        add(
          ActivityFetched(
            serverList: serverListCache,
            multiserver: multiserverCache,
            activeServerId: activeServerIdCache!,
            settingsBloc: settingsBlocCache,
          ),
        );
      });
    }
  }

  Future<void> _onActivityAutoRefreshStop(
    ActivityAutoRefreshStop event,
    Emitter<ActivityState> emit,
  ) async {
    _timer?.cancel();
  }

  Future<List<ActivityModel>> _activityModelsWithPosterUris({
    required List<ActivityModel> activityList,
    required String tautulliId,
    required SettingsBloc settingsBloc,
  }) async {
    List<ActivityModel> activityWithImages = [];

    for (ActivityModel activity in activityList) {
      Uri? imageUri;
      Uri? parentImageUri;
      Uri? grandparentImageUri;

      if (activity.thumb != null || activity.ratingKey != null) {
        final failureOrImageUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliId,
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
                tautulliId: tautulliId,
                primaryActive: imageUriTuple.value2,
              ),
            );

            imageUri = imageUriTuple.value1;
          },
        );
      }

      if (activity.parentThumb != null || activity.parentRatingKey != null) {
        final failureOrParentImageUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliId,
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
                tautulliId: tautulliId,
                primaryActive: imageUriTuple.value2,
              ),
            );

            parentImageUri = imageUriTuple.value1;
          },
        );
      }

      if (activity.grandparentThumb != null || activity.grandparentRatingKey != null) {
        final failureOrGrandparentImageUrl = await imageUrl.getImageUrl(
          tautulliId: tautulliId,
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
                tautulliId: tautulliId,
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
