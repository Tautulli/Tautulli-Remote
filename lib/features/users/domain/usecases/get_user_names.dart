import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class GetUserNames {
  final UsersRepository repository;

  GetUserNames({@required this.repository});

  Future<Either<Failure, List<User>>> call({
    @required String tautulliId,
  }) async {
    return await repository.getUserNames(tautulliId: tautulliId);
  }
}
