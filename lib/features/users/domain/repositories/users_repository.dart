import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/user.dart';
import '../entities/user_table.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<User>>> getUserNames({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });
  Future<Either<Failure, List<UserTable>>> getUsersTable({
    @required String tautulliId,
    int grouping,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  });
}
