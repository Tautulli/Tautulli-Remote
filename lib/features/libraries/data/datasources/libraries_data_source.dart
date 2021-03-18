import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../models/library_model.dart';

abstract class LibrariesDataSource {
  Future<List<Library>> getLibrariesTable({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
    @required SettingsBloc settingsBloc,
  });
}

class LibrariesDataSourceImpl implements LibrariesDataSource {
  final tautulliApi.GetLibrariesTable apiGetLibrariesTable;

  LibrariesDataSourceImpl({@required this.apiGetLibrariesTable});

  @override
  Future<List<Library>> getLibrariesTable({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
    @required SettingsBloc settingsBloc,
  }) async {
    final librariesJson = await apiGetLibrariesTable(
      tautulliId: tautulliId,
      grouping: grouping,
      length: length,
      orderColumn: orderColumn,
      orderDir: orderDir,
      search: search,
      start: start,
      settingsBloc: settingsBloc,
    );

    final List<Library> librariesList = [];

    librariesJson['response']['data']['data'].forEach((library) {
      librariesList.add(LibraryModel.fromJson(library));
    });

    return librariesList;
  }
}
