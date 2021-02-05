import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/library.dart';
import '../repositories/libraries_repository.dart';

class GetLibrariesTable {
  final LibrariesRepository repository;

  GetLibrariesTable({@required this.repository});

  Future<Either<Failure, List<Library>>> call({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  }) async {
    return await repository.getLibrariesTable(
      tautulliId: tautulliId,
      grouping: grouping,
      length: length,
      orderColumn: orderColumn,
      orderDir: orderDir,
      search: search,
      start: start,
    );
  }
}
