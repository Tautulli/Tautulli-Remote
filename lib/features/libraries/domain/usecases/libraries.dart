import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/library_table_model.dart';
import '../repositories/libraries_repository.dart';

class Libraries {
  final LibrariesRepository repository;

  Libraries({required this.repository});

  /// Returns a list of <LibrariesTableModel>.
  Future<Either<Failure, Tuple2<List<LibraryTableModel>, bool>>>
      getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    return await repository.getLibrariesTable(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );
  }
}
