import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class ActivityRepository {
  Future<Either<Failure, Map<String, Map<String, Object>>>> getActivity();
}