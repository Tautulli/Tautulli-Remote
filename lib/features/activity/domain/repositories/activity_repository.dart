import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/activity_model.dart';

abstract class ActivityRepository {
  Future<Either<Failure, Tuple2<List<ActivityModel>, bool>>> getActivity({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  });

  Future<Either<Failure, Tuple2<void, bool>>> terminateStream({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  });
}
