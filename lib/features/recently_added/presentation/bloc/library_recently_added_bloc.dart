import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../image_url/domain/usecases/image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/recently_added_model.dart';
import '../../domain/usecases/recently_added.dart';

part 'library_recently_added_event.dart';
part 'library_recently_added_state.dart';

Map<String, List<RecentlyAddedModel>> recentlyAddedCache = {};

const throttleDuration = Duration(milliseconds: 100);
const count = 50;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class LibraryRecentlyAddedBloc extends Bloc<LibraryRecentlyAddedEvent, LibraryRecentlyAddedState> {
  final RecentlyAdded recentlyAdded;
  final ImageUrl imageUrl;
  final Logging logging;

  LibraryRecentlyAddedBloc({
    required this.recentlyAdded,
    required this.imageUrl,
    required this.logging,
  }) : super(const LibraryRecentlyAddedState()) {
    on<LibraryRecentlyAddedFetched>(
      _onLibraryRecentlyAddedFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _onLibraryRecentlyAddedFetched(
    LibraryRecentlyAddedFetched event,
    Emitter<LibraryRecentlyAddedState> emit,
  ) async {
    final cacheKey = '${event.tautulliId}:${event.sectionId}';

    if (!recentlyAddedCache.containsKey(cacheKey)) {
      recentlyAddedCache[cacheKey] = [];
    }

    if (event.freshFetch) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
        ),
      );
      recentlyAddedCache[cacheKey] = [];
    }

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to New tab
      if (recentlyAddedCache[cacheKey]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
            recentlyAdded: recentlyAddedCache[cacheKey],
          ),
        );
      }

      final failureOrRecentlyAdded = await recentlyAdded.getRecentlyAdded(
        tautulliId: event.tautulliId,
        count: count,
        sectionId: event.sectionId,
      );

      return _emitFailureOrRecentlyAdded(
        cacheKey: cacheKey,
        event: event,
        emit: emit,
        failureOrRecentlyAdded: failureOrRecentlyAdded,
      );
    } else {
      final failureOrRecentlyAdded = await recentlyAdded.getRecentlyAdded(
        tautulliId: event.tautulliId,
        count: count,
        sectionId: event.sectionId,
        start: recentlyAddedCache[cacheKey]!.length,
      );

      return _emitFailureOrRecentlyAdded(
        cacheKey: cacheKey,
        event: event,
        emit: emit,
        failureOrRecentlyAdded: failureOrRecentlyAdded,
      );
    }
  }

  void _emitFailureOrRecentlyAdded({
    required String cacheKey,
    required LibraryRecentlyAddedFetched event,
    required Emitter<LibraryRecentlyAddedState> emit,
    required Either<Failure, Tuple2<List<RecentlyAddedModel>, bool>> failureOrRecentlyAdded,
  }) async {
    await failureOrRecentlyAdded.fold(
      (failure) async {
        logging.error('Libraries :: Failed to fetch recently added for Library ID ${event.sectionId} [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            recentlyAdded: event.freshFetch ? recentlyAddedCache[cacheKey] : state.recentlyAdded,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (recentlyAdded) async {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.tautulliId,
            primaryActive: recentlyAdded.value2,
          ),
        );

        // Add posters to recently added models
        List<RecentlyAddedModel> recentlyAddedListWithUris = await _recentlyAddedModelsWithPosterUris(
          tautulliId: event.tautulliId,
          recentlyAddedList: recentlyAdded.value1,
          settingsBloc: event.settingsBloc,
        );

        recentlyAddedCache[cacheKey] = recentlyAddedCache[cacheKey]! + recentlyAddedListWithUris;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            recentlyAdded: recentlyAddedCache[cacheKey],
          ),
        );
      },
    );
  }

  Future<List<RecentlyAddedModel>> _recentlyAddedModelsWithPosterUris({
    required String tautulliId,
    required List<RecentlyAddedModel> recentlyAddedList,
    required SettingsBloc settingsBloc,
  }) async {
    List<RecentlyAddedModel> recentlyAddedWithImages = [];

    for (RecentlyAddedModel recentItem in recentlyAddedList) {
      //* Fetch and assign image URLs
      String? posterImg;
      int? posterRatingKey;

      // Assign values for poster URL
      switch (recentItem.mediaType) {
        case (MediaType.movie):
          posterImg = recentItem.thumb;
          posterRatingKey = recentItem.ratingKey;
          break;
        case (MediaType.episode):
          posterImg = recentItem.grandparentThumb;
          posterRatingKey = recentItem.grandparentRatingKey;
          break;
        case (MediaType.season):
          posterImg = recentItem.thumb;
          posterRatingKey = recentItem.ratingKey;
          break;
        case (MediaType.track):
          posterImg = recentItem.thumb;
          posterRatingKey = recentItem.parentRatingKey;
          break;
        default:
          posterRatingKey = recentItem.ratingKey;
      }

      final failureOrImageUrl = await imageUrl.getImageUrl(
        tautulliId: tautulliId,
        img: posterImg,
        ratingKey: posterRatingKey,
      );

      await failureOrImageUrl.fold(
        (failure) async {
          logging.error(
            'Libraries :: Failed to fetch recently added image url for ${recentItem.fullTitle} [$failure]',
          );

          recentlyAddedWithImages.add(recentItem);
        },
        (imageUri) async {
          settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: tautulliId,
              primaryActive: imageUri.value2,
            ),
          );

          recentlyAddedWithImages.add(
            recentItem.copyWith(
              posterUri: imageUri.value1,
            ),
          );
        },
      );
    }

    return recentlyAddedWithImages;
  }
}
