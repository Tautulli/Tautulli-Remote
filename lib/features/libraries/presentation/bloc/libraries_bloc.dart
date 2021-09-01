// @dart=2.9

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../image_url/domain/usecases/get_image_url.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../../domain/usecases/get_libraries_table.dart';

part 'libraries_event.dart';
part 'libraries_state.dart';

List<Library> _librariesListCache;
String _orderColumnCache;
String _orderDirCache;
String _tautulliIdCache;
SettingsBloc _settingsBlocCache;

class LibrariesBloc extends Bloc<LibrariesEvent, LibrariesState> {
  final GetLibrariesTable getLibrariesTable;
  final GetImageUrl getImageUrl;
  final Logging logging;

  LibrariesBloc({
    @required this.getLibrariesTable,
    @required this.getImageUrl,
    @required this.logging,
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
      _settingsBlocCache = event.settingsBloc;

      yield* _fetchLibraries(
        tautulliId: event.tautulliId,
        orderColumn: event.orderColumn,
        orderDir: event.orderDir,
        useCachedList: true,
        settingsBloc: _settingsBlocCache,
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
        settingsBloc: _settingsBlocCache,
      );

      _tautulliIdCache = event.tautulliId;
    }
  }

  Stream<LibrariesState> _fetchLibraries({
    @required String tautulliId,
    String orderColumn,
    String orderDir,
    bool useCachedList = false,
    @required SettingsBloc settingsBloc,
  }) async* {
    if (useCachedList &&
        _librariesListCache != null &&
        _tautulliIdCache == tautulliId) {
      yield LibrariesSuccess(
        librariesList: _librariesListCache,
      );
    }
    final failureOrLibraries = await getLibrariesTable(
      tautulliId: tautulliId,
      orderColumn: orderColumn,
      orderDir: orderDir,
      settingsBloc: settingsBloc,
    );

    yield* failureOrLibraries.fold(
      (failure) async* {
        logging.error(
          'Libraries: Failed to load libraries',
        );

        yield LibrariesFailure(
          failure: failure,
          message: FailureMapperHelper.mapFailureToMessage(failure),
          suggestion: FailureMapperHelper.mapFailureToSuggestion(failure),
        );
      },
      (librariesList) async* {
        List<Library> updatedList = [];

        for (Library library in librariesList) {
          String backgroundUrl;
          String iconUrl;

          final backgroundImageUrlOrFailure = await getImageUrl(
            tautulliId: tautulliId,
            img: library.libraryArt,
            width: 500,
            height: 280,
            settingsBloc: settingsBloc,
          );

          backgroundImageUrlOrFailure.fold(
            (failure) {
              logging.warning(
                'Activity: Failed to load art for library ${library.sectionName}',
              );
            },
            (url) {
              backgroundUrl = url;
            },
          );

          if (library.libraryThumb.contains('http')) {
            final iconImageUrlOrFailure = await getImageUrl(
              tautulliId: tautulliId,
              img: library.libraryThumb,
              settingsBloc: settingsBloc,
            );

            iconImageUrlOrFailure.fold(
              (failure) {
                logging.warning(
                  'Activity: Failed to load icon for library ${library.sectionName}',
                );
              },
              (url) {
                iconUrl = url;
              },
            );
          }
          updatedList.add(library.copyWith(
            backgroundUrl: backgroundUrl,
            iconUrl: iconUrl,
          ));
        }

        _librariesListCache = updatedList;

        yield LibrariesSuccess(
          librariesList: updatedList,
        );
      },
    );
  }
}

void clearCache() {
  _librariesListCache = null;
  _orderColumnCache = null;
  _orderDirCache = null;
  _tautulliIdCache = null;
}
