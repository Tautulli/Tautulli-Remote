import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_table.dart';
import '../repositories/users_table_repository.dart';

class GetUsersTable {
  final UsersTableRepository repository;

  GetUsersTable({@required this.repository});

  Future<Either<Failure, List<UserTable>>> call({
    @required tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
  }) async {
    return await repository.getUsersTable(
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
