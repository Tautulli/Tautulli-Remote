import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/endpoints/get_libraries_table.dart';
import '../../../../core/types/section_type.dart';
import '../models/library_table_model.dart';

abstract class LibrariesDataSource {
  Future<Tuple2<List<LibraryTableModel>, bool>> getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });
}

class LibrariesDataSourceImpl implements LibrariesDataSource {
  final GetLibrariesTable getLibrariesTableApi;

  LibrariesDataSourceImpl({
    required this.getLibrariesTableApi,
  });

  @override
  Future<Tuple2<List<LibraryTableModel>, bool>> getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    final result = await getLibrariesTableApi(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );

    final List<LibraryTableModel> librariesList = result.value1['response']
            ['data']['data']
        .map<LibraryTableModel>((librariesItem) {
      LibraryTableModel library = LibraryTableModel.fromJson(librariesItem);

      if (library.live == true) {
        library = library.copyWith(sectionType: SectionType.live);
      }

      if (library.guid != null &&
          library.guid!.startsWith('com.plexapp.agents.none')) {
        library = library.copyWith(sectionType: SectionType.video);
      }

      return library;
    }).toList();

    return Tuple2(librariesList, result.value2);
  }
}
