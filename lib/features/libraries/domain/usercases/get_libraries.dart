import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/library.dart';
import '../repositories/libraries_repository.dart';

class GetLibraries {
  final LibrariesRepository repository;

  GetLibraries({@required this.repository});

  Future<Either<Failure, List<Library>>> call({
    @required String tautulliId,
  }) async {
    return await repository.getLibraries(tautulliId: tautulliId);
  }
}
