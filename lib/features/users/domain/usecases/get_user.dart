// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/user_table.dart';
import '../repositories/users_repository.dart';

class GetUser {
  final UsersRepository repository;

  GetUser({@required this.repository});

  Future<Either<Failure, UserTable>> call({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getUser(
      tautulliId: tautulliId,
      userId: userId,
      settingsBloc: settingsBloc,
    );
  }
}
