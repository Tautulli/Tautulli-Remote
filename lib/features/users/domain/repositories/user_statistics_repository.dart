import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/user_statistic.dart';

abstract class UserStatisticsRepository {
  Future<Either<Failure, List<UserStatistic>>> getUserWatchTimeStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
  Future<Either<Failure, List<UserStatistic>>> getUserPlayerStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
}
