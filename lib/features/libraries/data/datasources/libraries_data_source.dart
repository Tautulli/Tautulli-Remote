import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
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
  });
}

class LibrariesDataSourceImpl implements LibrariesDataSource {
  final TautulliApi tautulliApi;

  LibrariesDataSourceImpl({@required this.tautulliApi});

  @override
  Future<List<Library>> getLibrariesTable({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  }) async {
    final librariesJson = await tautulliApi.getLibrariesTable(
      tautulliId: tautulliId,
      grouping: grouping,
      length: length,
      orderColumn: orderColumn,
      orderDir: orderDir,
      search: search,
      start: start,
    );

    final List<Library> librariesList = [];

    librariesJson['response']['data']['data'].forEach((library) {
      librariesList.add(LibraryModel.fromJson(library));
    });

    return librariesList;
  }
}
