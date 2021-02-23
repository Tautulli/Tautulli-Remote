import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
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
    int timeoutOverride,
  });
}

class LibraryMediaDataSourceImpl implements LibraryMediaDataSource {
  final tautulliApi.GetLibraryMediaInfo apiGetLibraryMediaInfo;

  LibraryMediaDataSourceImpl({@required this.apiGetLibraryMediaInfo});

  @override
  Future<List<LibraryMedia>> getLibraryMediaInfo({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir,
    int start,
    int length,
    bool refresh,
    int timeoutOverride,
  }) async {
    final libraryMediaInfoJson = await apiGetLibraryMediaInfo(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      sectionId: sectionId,
      orderDir: orderDir,
      start: start,
      length: length,
      refresh: refresh,
      timeoutOverride: timeoutOverride,
    );

    List libraryMediaInfoMap = libraryMediaInfoJson['response']['data']['data'];

    final List<LibraryMedia> libraryMediaList = [];

    libraryMediaInfoMap.forEach((item) {
      libraryMediaList.add(LibraryMediaModel.fromJson(item));
    });

    return libraryMediaList;
  }
}
