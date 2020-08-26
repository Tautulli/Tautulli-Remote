import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../domain/entities/library.dart';
import '../../domain/usercases/get_libraries.dart';

part 'libraries_event.dart';
part 'libraries_state.dart';

class LibrariesBloc extends Bloc<LibrariesEvent, LibrariesState> {
  final GetLibraries getLibraries;
  final GetImageUrl getImageUrl;

  LibrariesBloc({
    @required this.getLibraries,
    @required this.getImageUrl,
  }) : super(LibrariesInitial());

  @override
  Stream<LibrariesState> mapEventToState(
    LibrariesEvent event,
  ) async* {
    if (event is LibrariesFetch) {
      yield* _fetchLibraries(tautulliId: event.tautulliId);
    }
    if (event is LibrariesFilter) {
      yield LibrariesInitial();
      yield* _fetchLibraries(tautulliId: event.tautulliId);
    }
  }

  Stream<LibrariesState> _fetchLibraries({
    @required String tautulliId,
  }) async* {
    final librariesOrFailure = await getLibraries(
      tautulliId: tautulliId,
    );

    yield* librariesOrFailure.fold(
      (failure) async* {
        yield LibrariesFailure(
          failure: failure,
          message: FailureMapperHelper().mapFailureToMessage(failure),
          suggestion: FailureMapperHelper().mapFailureToSuggestion(failure),
        );
      },
      (librariesList) async* {
        Map<String, List<Library>> librariesMap = {
          'movie': [],
          'show': [],
          'artist': [],
          'photo': [],
        };
        Map<String, String> imageMap = {};

        // Add libraries into proper type list in librariesMap
        for (int i = 0; i < librariesList.length; i++) {
          librariesMap[librariesList[i].sectionType].add(librariesList[i]);
        }

        // Sort library type lists and get background image
        for (String key in librariesMap.keys) {
          librariesMap[key].sort((a, b) {
            var result = b.count.compareTo(a.count);
            if (result != 0) {
              return result;
            }
            if (b.parentCount != null) {
              result = b.parentCount.compareTo(a.parentCount);
              if (result != 0) {
                return result;
              }
            }
            if (b.childCount != null) {
              result = b.childCount.compareTo(a.childCount);
              if (result != 0) {
                return result;
              }
            }
            return a.sectionName.compareTo(b.sectionName);
          });

          if (librariesMap[key].length > 0) {
            final imageUrlOrFailure = await getImageUrl(
              tautulliId: tautulliId,
              img: librariesMap[key][0].art,
            );

            imageUrlOrFailure.fold(
              (failure) => null,
              (url) {
                imageMap[key] = url;
              },
            );
          }
        }

        yield LibrariesSuccess(
          librariesMap: librariesMap,
          imageMap: imageMap,
          librariesCount: librariesList.length,
        );
      },
    );
  }
}
