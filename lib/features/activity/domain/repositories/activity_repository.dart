import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/activity.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<ActivityItem>>> getActivity();
}