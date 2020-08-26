import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../domain/entities/library.dart';
import '../models/library_model.dart';

abstract class LibrariesDataSource {
  Future<List<Library>> getLibraries({
    @required String tautulliId,
  });
}

class LibrariesDataSourceImpl implements LibrariesDataSource {
  final TautulliApi tautulliApi;

  LibrariesDataSourceImpl({@required this.tautulliApi});

  @override
  Future<List<Library>> getLibraries({
    @required String tautulliId,
  }) async {
    final librariesJson =
        await tautulliApi.getLibraries(tautulliId: tautulliId);

    final List<Library> librariesList = [];

    librariesJson['response']['data'].forEach((library) {
      librariesList.add(LibraryModel.fromJson(library));
    });

    return librariesList;
  }
}
