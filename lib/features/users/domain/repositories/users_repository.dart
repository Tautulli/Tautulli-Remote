import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../entities/user_table.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<User>>> getUserNames({
    @required tautulliId,
  });
  Future<Either<Failure, List<UserTable>>> getUsersTable({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  });
}
