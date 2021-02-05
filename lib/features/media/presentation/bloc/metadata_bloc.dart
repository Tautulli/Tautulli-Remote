import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../domain/entities/metadata_item.dart';
import '../../domain/usecases/get_metadata.dart';

part 'metadata_event.dart';
part 'metadata_state.dart';

String _tautulliIdCache;
Map<int, MetadataItem> _metadataCache = {};

class MetadataBloc extends Bloc<MetadataEvent, MetadataState> {
  final GetMetadata getMetadata;

  MetadataBloc({
    @required this.getMetadata,
  }) : super(MetadataInitial());

  @override
  Stream<MetadataState> mapEventToState(
    MetadataEvent event,
  ) async* {
    if (event is MetadataFetched) {
      if (_tautulliIdCache == event.tautulliId &&
          (_metadataCache.containsKey(event.ratingKey) ||
              _metadataCache.containsKey(event.syncId))) {
        MetadataItem cachedMetadata;
        if (event.ratingKey != null) {
          cachedMetadata = _metadataCache[event.ratingKey];
        } else if (event.syncId != null) {
          cachedMetadata = _metadataCache[event.syncId];
        }
        yield MetadataSuccess(metadata: cachedMetadata);
      } else {
        yield MetadataInProgress();

        final failureorMetadata = await getMetadata(
          tautulliId: event.tautulliId,
          ratingKey: event.ratingKey,
          syncId: event.syncId,
        );

        yield* failureorMetadata.fold(
          (failure) async* {
            yield MetadataFailure(
              failure: failure,
              message: FailureMapperHelper.mapFailureToMessage(failure),
              suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
            );
          },
          (metadata) async* {
            if (event.ratingKey != null) {
              _metadataCache[event.ratingKey] = metadata;
            } else if (event.syncId != null) {
              _metadataCache[event.syncId] = metadata;
            }

            yield MetadataSuccess(metadata: metadata);
          },
        );
      }

      _tautulliIdCache = event.tautulliId;
    }
  }
}

void clearCache() {
  _metadataCache = {};
  _tautulliIdCache = null;
}
