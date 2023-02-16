import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/activity_model.dart';
import '../repositories/activity_repository.dart';

class Activity {
  final ActivityRepository repository;

  Activity({required this.repository});

  Future<Either<Failure, Tuple2<List<ActivityModel>, bool>>> getActivity({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  }) async {
    return await repository.getActivity(
      tautulliId: tautulliId,
      sessionKey: sessionKey,
      sessionId: sessionId,
    );
  }

  Future<Either<Failure, Tuple2<void, bool>>> terminateStream({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  }) async {
    return await repository.terminateStream(
      tautulliId: tautulliId,
      sessionId: sessionId,
      sessionKey: sessionKey,
      message: message,
    );
  }
}
