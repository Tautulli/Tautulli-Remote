import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../domain/entities/library.dart';
import '../../domain/usercases/get_libraries_table.dart';

part 'libraries_event.dart';
part 'libraries_state.dart';

List<Library> _librariesListCache;
Map<int, String> _imageMapCache;
String _orderColumnCache;
String _orderDirCache;
String _tautulliIdCache;

class LibrariesBloc extends Bloc<LibrariesEvent, LibrariesState> {
  final GetLibrariesTable getLibrariesTable;
  final GetImageUrl getImageUrl;

  LibrariesBloc({
    @required this.getLibrariesTable,
    @required this.getImageUrl,
  }) : super(LibrariesInitial(
          orderColumn: _orderColumnCache,
          orderDir: _orderDirCache,
        ));

  @override
  Stream<LibrariesState> mapEventToState(
    LibrariesEvent event,
  ) async* {
    if (event is LibrariesFetch) {
      _orderColumnCache = event.orderColumn;
      _orderDirCache = event.orderDir;

      yield* _fetchLibraries(
        tautulliId: event.tautulliId,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        useCachedList: true,
      );

      _tautulliIdCache = event.tautulliId;
    }
    if (event is LibrariesFilter) {
      _orderColumnCache = event.orderColumn;
      _orderDirCache = event.orderDir;

      yield LibrariesInitial();
      yield* _fetchLibraries(
        tautulliId: event.tautulliId,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<LibrariesState> _fetchLibraries({
    @required String tautulliId,
    String orderColumn,
    String orderDir,
    bool useCachedList = false,
  }) async* {
    if (useCachedList &&
        _librariesListCache != null &&
        _tautulliIdCache == tautulliId) {
      yield LibrariesSuccess(
        librariesList: _librariesListCache,
        imageMap: _imageMapCache,
      );
    }
    final librariesOrFailure = await getLibrariesTable(
      tautulliId: tautulliId,
      orderColumn: orderColumn,
      orderDir: orderDir,
    );

    yield* librariesOrFailure.fold(
      (failure) async* {
        yield LibrariesFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (librariesList) async* {
        Map<int, String> imageMap = {};

        for (Library library in librariesList) {
          final imageUrlOrFailure = await getImageUrl(
            tautulliId: tautulliId,
            img: library.libraryArt,
          );

          imageUrlOrFailure.fold(
            (failure) => null,
            (url) {
              imageMap[library.sectionId] = url;
            },
          );
        }

        _librariesListCache = librariesList;
        _imageMapCache = imageMap;

        yield LibrariesSuccess(
          librariesList: librariesList,
          imageMap: imageMap,
        );
      },
    );
  }
}

void clearCache() {
  _librariesListCache = null;
  _imageMapCache = null;
  _orderColumnCache = null;
  _orderDirCache = null;
  _tautulliIdCache = null;
}
