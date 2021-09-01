// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class GetUserNames {
  final UsersRepository repository;

  GetUserNames({@required this.repository});

  Future<Either<Failure, List<User>>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getUserNames(
      tautulliId: tautulliId,
      settingsBloc: settingsBloc,
    );
  }
}
