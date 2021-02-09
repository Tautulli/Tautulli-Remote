import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../domain/entities/library_media.dart';
import '../models/library_media_model.dart';

abstract class LibraryMediaDataSource {
  Future<List<LibraryMedia>> getLibraryMediaInfo({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir,
    int start,
    int length,
    bool refresh,
  });
}

class LibraryMediaDataSourceImpl implements LibraryMediaDataSource {
  final TautulliApi tautulliApi;

  LibraryMediaDataSourceImpl({@required this.tautulliApi});

  @override
  Future<List<LibraryMedia>> getLibraryMediaInfo({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir,
    int start,
    int length,
    bool refresh,
  }) async {
    final libraryMediaInfoJson = await tautulliApi.getLibraryMediaInfo(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      sectionId: sectionId,
      orderDir: orderDir,
      start: start,
      length: length,
      refresh: refresh,
    );

    List libraryMediaInfoMap = libraryMediaInfoJson['response']['data']['data'];

    final List<LibraryMedia> libraryMediaList = [];

    libraryMediaInfoMap.forEach((item) {
      libraryMediaList.add(LibraryMediaModel.fromJson(item));
    });

    return libraryMediaList;
  }
}
