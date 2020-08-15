import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class GetUsers {
  final UsersRepository repository;

  GetUsers({@required this.repository});

  Future<Either<Failure, List<User>>> call({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
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
