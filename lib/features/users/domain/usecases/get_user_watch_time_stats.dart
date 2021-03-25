import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/user_statistic.dart';
import '../repositories/user_statistics_repository.dart';

class GetUserWatchTimeStats {
  final UserStatisticsRepository repository;

  GetUserWatchTimeStats({@required this.repository});

  Future<Either<Failure, List<UserStatistic>>> call({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getUserWatchTimeStats(
      tautulliId: tautulliId,
      userId: userId,
      settingsBloc: settingsBloc,
    );
  }
}
