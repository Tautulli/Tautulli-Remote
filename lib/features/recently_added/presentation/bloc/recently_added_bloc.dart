import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/recently_added_model.dart';
import '../../domain/usecases/recently_added.dart';

part 'recently_added_event.dart';
part 'recently_added_state.dart';

String? tautulliIdCache;
Map<String, List<RecentlyAddedModel>> recentlyAddedCache = {};
MediaType? mediaTypeCache;
bool hasReachedMaxCache = false;

const throttleDuration = Duration(milliseconds: 100);
const count = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class RecentlyAddedBloc extends Bloc<RecentlyAddedEvent, RecentlyAddedState> {
  final RecentlyAdded recentlyAdded;
  final ImageUrl imageUrl;
  final Logging logging;

  RecentlyAddedBloc({
    required this.recentlyAdded,
    required this.imageUrl,
    required this.logging,
  }) : super(
          RecentlyAddedState(
            recentlyAdded: tautulliIdCache != null ? recentlyAddedCache[tautulliIdCache]! : [],
            hasReachedMax: hasReachedMaxCache,
          ),
        ) {
    on<RecentlyAddedFetched>(
      _onRecentlyAddedFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _onRecentlyAddedFetched(
    RecentlyAddedFetched event,
    Emitter<RecentlyAddedState> emit,
  ) async {
    if (event.server.id == null) {
      Failure failure = MissingServerFailure();

      return emit(
        state.copyWith(
          status: BlocStatus.failure,
          failure: failure,
          message: FailureHelper.mapFailureToMessage(failure),
          suggestion: FailureHelper.mapFailureToSuggestion(failure),
        ),
      );
    }

    final bool serverChange = tautulliIdCache != event.server.tautulliId;

    if (!recentlyAddedCache.containsKey(event.server.tautulliId)) {
      recentlyAddedCache[event.server.tautulliId] = [];
    }

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          recentlyAdded: serverChange ? [] : null,
          hasReachedMax: false,
        ),
      );
      recentlyAddedCache[event.server.tautulliId] = [];
      hasReachedMaxCache = false;
    }

    tautulliIdCache = event.server.tautulliId;
    mediaTypeCache = event.mediaType;

    if (state.hasReachedMax) return;

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to Recently Added page
      if (recentlyAddedCache[event.server.tautulliId]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }
      final failureOrRecentlyAdded = await recentlyAdded.getRecentlyAdded(
        tautulliId: event.server.tautulliId,
        count: event.mediaType == null ? 50 : count,
        mediaType: event.mediaType,
        sectionId: event.sectionId,
      );

      return _emitFailureOrRecentlyAdded(
        event: event,
        emit: emit,
        failureOrRecentlyAdded: failureOrRecentlyAdded,
      );
    } else {
      // Make sure bottom loader loading indicator displays when
      // attempting to fetch
      emit(
        state.copyWith(status: BlocStatus.success),
      );

      final failureOrRecentlyAdded = await recentlyAdded.getRecentlyAdded(
        tautulliId: event.server.tautulliId,
        count: count,
        mediaType: event.mediaType,
        sectionId: event.sectionId,
        start: recentlyAddedCache[event.server.tautulliId]!.length,
      );

      return _emitFailureOrRecentlyAdded(
        event: event,
        emit: emit,
        failureOrRecentlyAdded: failureOrRecentlyAdded,
      );
    }
  }

  void _emitFailureOrRecentlyAdded({
    required RecentlyAddedFetched event,
    required Emitter<RecentlyAddedState> emit,
    required Either<Failure, Tuple2<List<RecentlyAddedModel>, bool>> failureOrRecentlyAdded,
  }) async {
    await failureOrRecentlyAdded.fold(
      (failure) async {
        logging.error('RecentlyAdded :: Failed to fetch recently added [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            recentlyAdded: event.freshFetch ? recentlyAddedCache[event.server.tautulliId] : state.recentlyAdded,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (recentlyAdded) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: recentlyAdded.value2,
          ),
        );

        // Add posters to recently added models
        List<RecentlyAddedModel> recentlyAddedListWithUris = await _recentlyAddedModelsWithPosterUris(
          recentlyAddedList: recentlyAdded.value1,
          settingsBloc: event.settingsBloc,
        );

        recentlyAddedCache[event.server.tautulliId] = recentlyAddedCache[event.server.tautulliId]! + recentlyAddedListWithUris;
        hasReachedMaxCache = recentlyAddedListWithUris.length < count;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            recentlyAdded: recentlyAddedCache[event.server.tautulliId],
            hasReachedMax: event.mediaType == null ? true : hasReachedMaxCache,
          ),
        );
      },
    );
  }

  Future<List<RecentlyAddedModel>> _recentlyAddedModelsWithPosterUris({
    required List<RecentlyAddedModel> recentlyAddedList,
    required SettingsBloc settingsBloc,
  }) async {
    List<RecentlyAddedModel> recentlyAddedWithImages = [];

    for (RecentlyAddedModel recentItem in recentlyAddedList) {
      Uri? posterUri;
      Uri? parentPosterUri;
      Uri? grandparentPosterUri;

      final failureOrPosterUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliIdCache!,
        img: recentItem.thumb,
        ratingKey: recentItem.ratingKey,
      );

      final failureOrParentPosterUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliIdCache!,
        img: recentItem.parentThumb,
        ratingKey: recentItem.parentRatingKey,
      );

      final failureOrGrandparentPosterUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliIdCache!,
        img: recentItem.grandparentThumb,
        ratingKey: recentItem.grandparentRatingKey,
      );

      await failureOrPosterUrl.fold(
        (failure) async {
          logging.error(
            'RecentlyAdded :: Failed to fetch image url for ${recentItem.fullTitle} [$failure]',
          );
        },
        (imageUri) async {
          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliIdCache!,
              primaryActive: imageUri.value2,
            ),
          );

          posterUri = imageUri.value1;
        },
      );

      await failureOrParentPosterUrl.fold(
        (failure) async {
          logging.error(
            'RecentlyAdded :: Failed to fetch parent image url for ${recentItem.fullTitle} [$failure]',
          );
        },
        (imageUri) async {
          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliIdCache!,
              primaryActive: imageUri.value2,
            ),
          );

          parentPosterUri = imageUri.value1;
        },
      );

      await failureOrGrandparentPosterUrl.fold(
        (failure) async {
          logging.error(
            'RecentlyAdded :: Failed to fetch grandparent image url for ${recentItem.fullTitle} [$failure]',
          );
        },
        (imageUri) async {
          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliIdCache!,
              primaryActive: imageUri.value2,
            ),
          );

          grandparentPosterUri = imageUri.value1;
        },
      );

      recentlyAddedWithImages.add(
        recentItem.copyWith(
          posterUri: posterUri,
          parentPosterUri: parentPosterUri,
          grandparentPosterUri: grandparentPosterUri,
        ),
      );
    }

    return recentlyAddedWithImages;
  }
}
