import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../repositories/terminate_session_repository.dart';

class TerminateSession {
  final TerminateSessionRepository repository;

  TerminateSession({@required this.repository});

  Future<Either<Failure, bool>> call({
    @required String tautulliId,
    @required String sessionId,
    String message,
  }) async {
    return await repository(
      tautulliId: tautulliId,
      sessionId: sessionId,
      message: message,
    );
  }
}
