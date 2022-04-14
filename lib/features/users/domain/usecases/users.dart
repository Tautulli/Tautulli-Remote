import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/user_model.dart';
import '../repositories/users_repository.dart';

class Users {
  final UsersRepository repository;

  Users({required this.repository});

  // Returns all Tautulli users as a list of `UserModel`.
  Future<Either<Failure, Tuple2<List<UserModel>, bool>>> getUsers({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    return await repository.getUsers(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );
  }
}
