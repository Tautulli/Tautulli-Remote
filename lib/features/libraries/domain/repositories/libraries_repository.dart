import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/library_table_model.dart';

abstract class LibrariesRepository {
  Future<Either<Failure, Tuple2<List<LibraryTableModel>, bool>>>
      getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });
}
