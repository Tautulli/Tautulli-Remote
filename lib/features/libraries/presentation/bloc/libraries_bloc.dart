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

class LibrariesBloc extends Bloc<LibrariesEvent, LibrariesState> {
  final GetLibrariesTable getLibrariesTable;
  final GetImageUrl getImageUrl;

  LibrariesBloc({
    @required this.getLibrariesTable,
    @required this.getImageUrl,
  }) : super(LibrariesInitial());

  @override
  Stream<LibrariesState> mapEventToState(
    LibrariesEvent event,
  ) async* {
    if (event is LibrariesFetch) {
      yield* _fetchLibraries(
        tautulliId: event.tautulliId,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
      );
    }
    if (event is LibrariesFilter) {
      yield LibrariesInitial();
      yield* _fetchLibraries(
        tautulliId: event.tautulliId,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
      );
    }
  }

  Stream<LibrariesState> _fetchLibraries({
    @required String tautulliId,
    String orderColumn,
    String orderDir,
  }) async* {
    final librariesOrFailure = await getLibrariesTable(
      tautulliId: tautulliId,
      orderColumn: orderColumn,
      orderDir: orderDir,
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

        yield LibrariesSuccess(
          librariesList: librariesList,
          imageMap: imageMap,
        );
      },
    );
  }
}
