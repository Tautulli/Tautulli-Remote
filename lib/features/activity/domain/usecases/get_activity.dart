import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class GetActivity {
  final ActivityRepository repository;

  GetActivity({@required this.repository});

  Future<Either<Failure, List<ActivityItem>>> call() async {
    return await repository.getActivity();
  }
}
