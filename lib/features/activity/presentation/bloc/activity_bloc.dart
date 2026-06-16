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

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final Activity activity;
  final ImageUrl imageUrl;
  final Logging logging;
  final Settings settings;
  final SettingsBloc settingsBloc;

  Timer? _timer;

  final List<ServerActivityModel> _serverActivityListCache = [];
  late List<ServerModel> _serverListCache;
  late bool _multiserverCache;
  String? _activeServerIdCache;
  bool _freshFetch = true;

  ActivityBloc({
    required this.activity,
    required this.imageUrl,
    required this.logging,
    required this.settings,
    required this.settingsBloc,
  }) : super(
         ActivityState(
           serverActivityList: const [],
           freshFetch: true,
           lastAutoRefresh: DateTime.now(),
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
    if (event.freshFetch) _freshFetch = true;

    if (event.serverList.isNotEmpty) {
      _serverListCache = event.serverList;
      _multiserverCache = event.multiserver;

      _addNewServers(event.serverList);

      _verifyActiveServerId(event.serverList, event.activeServerId);

      _removeOldServers(event.serverList);

      _updateServerSortIndex(event.serverList);

      _serverActivityListCache.sort(
        (a, b) => a.sortIndex.compareTo(b.sortIndex),
      );

      emit(
        state.copyWith(
          serverActivityList: [..._serverActivityListCache],
          freshFetch: _freshFetch,
          lastAutoRefresh: event.autoRefresh ? DateTime.now() : state.lastAutoRefresh,
        ),
      );

      if (event.multiserver) {
        for (ServerActivityModel serverActivityModel in _serverActivityListCache) {
          // Exclude servers already in the process of loading activity
          if (serverActivityModel.status != BlocStatus.inProgress) {
            // Set status to inProgress
            final index = _serverActivityListCache.indexWhere((e) => e.tautulliId == serverActivityModel.tautulliId);
            _serverActivityListCache[index] = serverActivityModel.copyWith(status: BlocStatus.inProgress);

            emit(
              state.copyWith(
                serverActivityList: [..._serverActivityListCache],
                freshFetch: _freshFetch,
                lastAutoRefresh: event.autoRefresh ? DateTime.now() : state.lastAutoRefresh,
              ),
            );

            _loadServer(
              serverActivityModel: serverActivityModel,
            );
          }
        }
      } else {
        final activeServerIndex = _serverActivityListCache.indexWhere(
          (server) => server.tautulliId == _activeServerIdCache,
        );

        // Update status to inProgress
        _serverActivityListCache[activeServerIndex] = _serverActivityListCache[activeServerIndex].copyWith(
          status: BlocStatus.inProgress,
        );

        emit(
          state.copyWith(
            serverActivityList: [..._serverActivityListCache],
            freshFetch: _freshFetch,
            lastAutoRefresh: event.autoRefresh ? DateTime.now() : state.lastAutoRefresh,
          ),
        );

        _loadServer(
          serverActivityModel: _serverActivityListCache[activeServerIndex],
        );
      }

      add(ActivityAutoRefreshStart());
    }
  }

  void _addNewServers(List<ServerModel> serverList) {
    for (ServerModel server in serverList) {
      final bool serverExistsInCache =
          _serverActivityListCache.indexWhere((e) => e.tautulliId == server.tautulliId) != -1 ? true : false;

      if (!serverExistsInCache) {
        _serverActivityListCache.add(
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
    _activeServerIdCache ??= activeServer.tautulliId;

    final activeServerIndex = _serverActivityListCache.indexWhere(
      (server) => server.tautulliId == activeServer.tautulliId,
    );
    // Clear activityList if active server was changed
    if (_activeServerIdCache != activeServer.tautulliId) {
      _serverActivityListCache[activeServerIndex] = _serverActivityListCache[activeServerIndex].copyWith(
        activityList: [],
      );
    }

    _activeServerIdCache = activeServer.tautulliId;
  }

  void _removeOldServers(List<ServerModel> serverList) {
    _serverActivityListCache.removeWhere(
      (serverActivityModel) =>
          serverList.indexWhere((server) => server.tautulliId == serverActivityModel.tautulliId) == -1,
    );
  }

  void _updateServerSortIndex(List<ServerModel> serverList) {
    for (ServerActivityModel serverActivityModel in _serverActivityListCache) {
      final int serverIndex = _serverActivityListCache.indexOf(serverActivityModel);
      final int sortIndex = serverList
          .firstWhere((server) => server.tautulliId == serverActivityModel.tautulliId)
          .sortIndex;

      _serverActivityListCache[serverIndex] = _serverActivityListCache[serverIndex].copyWith(sortIndex: sortIndex);
    }
  }

  void _loadServer({
    required ServerActivityModel serverActivityModel,
  }) {
    activity
        .getActivity(
          tautulliId: serverActivityModel.tautulliId,
        )
        .then(
          (failureOrActivity) {
            // When a quick action is used it is possible for the app to request activity before closing bloc and navigating
            // to a new page. This cases a StateError which is caught and the status is set to success to avoid the server
            // being stuck in inProgress
            try {
              add(
                ActivityLoadServer(
                  tautulliId: serverActivityModel.tautulliId,
                  serverName: serverActivityModel.serverName,
                  failureOrActivity: failureOrActivity,
                ),
              );
            } catch (_) {
              final int index = _serverActivityListCache.indexWhere(
                (server) => server.tautulliId == serverActivityModel.tautulliId,
              );

              _serverActivityListCache[index] = _serverActivityListCache[index].copyWith(
                status: BlocStatus.success,
                activityList: [],
              );
            }
          },
        );

    _freshFetch = false;
  }

  Future<void> _onActivityLoadServer(
    ActivityLoadServer event,
    Emitter<ActivityState> emit,
  ) async {
    final int index = _serverActivityListCache.indexWhere((server) => server.tautulliId == event.tautulliId);

    await event.failureOrActivity.fold(
      (failure) async {
        logging.error('Activity :: Failed to fetch activity for ${event.serverName} [$failure]');

        _serverActivityListCache[index] = _serverActivityListCache[index].copyWith(
          status: BlocStatus.failure,
          activityList: [],
          failure: failure,
          failureMessage: FailureHelper.mapFailureToMessage(failure),
          failureSuggestion: FailureHelper.mapFailureToSuggestion(failure),
        );
      },
      (activity) async {
        settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.tautulliId,
            primaryActive: activity.value2,
          ),
        );

        // Add posters to activity models
        List<ActivityModel> activityListWithUris = await _activityModelsWithPosterUris(
          activityList: activity.value1,
          tautulliId: event.tautulliId,
        );

        int copyCount = 0;
        int directPlayCount = 0;
        int transcodeCount = 0;
        int lanBandwidth = 0;
        int wanBandwidth = 0;

        for (int i = 0; i < activityListWithUris.length; i++) {
          if (activityListWithUris[i].transcodeDecision == StreamDecision.directPlay) directPlayCount += 1;
          if (activityListWithUris[i].transcodeDecision == StreamDecision.copy) {
            copyCount += 1;
          }
          if (activityListWithUris[i].transcodeDecision == StreamDecision.transcode) transcodeCount += 1;

          if (activityListWithUris[i].bandwidth != null) {
            if (activityListWithUris[i].location == Location.lan) {
              lanBandwidth += activityListWithUris[i].bandwidth!;
            } else {
              wanBandwidth += activityListWithUris[i].bandwidth!;
            }
          }
        }

        _serverActivityListCache[index] = _serverActivityListCache[index].copyWith(
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
        serverActivityList: [..._serverActivityListCache],
        freshFetch: _freshFetch,
      ),
    );
  }

  Future<void> _onActivityAutoRefreshStart(
    ActivityAutoRefreshStart event,
    Emitter<ActivityState> emit,
  ) async {
    _timer?.cancel();

    final refreshRate = settings.getRefreshRate();

    if (refreshRate > 0) {
      _timer = Timer.periodic(Duration(seconds: refreshRate), (timer) {
        final activeServerId = _activeServerIdCache;
        if (activeServerId == null) return;
        add(
          ActivityFetched(
            serverList: _serverListCache,
            multiserver: _multiserverCache,
            activeServerId: activeServerId,
            autoRefresh: true,
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

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<List<ActivityModel>> _activityModelsWithPosterUris({
    required List<ActivityModel> activityList,
    required String tautulliId,
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
