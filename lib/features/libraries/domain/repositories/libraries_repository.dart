import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/library.dart';

abstract class LibrariesRepository {
  Future<Either<Failure, List<Library>>> getLibrariesTable({
    @required String tautulliId,
    int grouping,
    int length,
    String orderColumn,
    String orderDir,
    String search,
    int start,
  });
}