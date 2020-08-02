import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';

abstract class TerminateSessionRepository {
  Future<Either<Failure, bool>> call({
    @required String tautulliId,
    @required String sessionId,
    String message,
  });
}