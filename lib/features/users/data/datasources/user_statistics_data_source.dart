import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_statistic.dart';
import '../models/user_statistic_model.dart';

abstract class UserStatisticsDataSource {
  Future<List> getUserWatchTimeStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
  Future<List> getUserPlayerStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  });
}

class UserStatisticsDataSourceImpl implements UserStatisticsDataSource {
  final tautulli_api.GetUserWatchTimeStats apiGetUserWatchTimeStats;
  final tautulli_api.GetUserPlayerStats apiGetUserPlayerStats;

  UserStatisticsDataSourceImpl({
    @required this.apiGetUserWatchTimeStats,
    @required this.apiGetUserPlayerStats,
  });

  @override
  Future<List> getUserWatchTimeStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    final userWatchTimeStatsJson = await apiGetUserWatchTimeStats(
      tautulliId: tautulliId,
      userId: userId,
      settingsBloc: settingsBloc,
    );

    final List<UserStatistic> userWatchTimeStatsList = [];
    userWatchTimeStatsJson['response']['data'].forEach((item) {
      userWatchTimeStatsList.add(
        UserStatisticModel.fromJson(
          userStatisticType: UserStatisticType.watchTime,
          json: item,
        ),
      );
    });

    return userWatchTimeStatsList;
  }

  @override
  Future<List> getUserPlayerStats({
    @required String tautulliId,
    @required int userId,
    @required SettingsBloc settingsBloc,
  }) async {
    final userPlayerStatsJson = await apiGetUserPlayerStats(
      tautulliId: tautulliId,
      userId: userId,
      settingsBloc: settingsBloc,
    );

    final List<UserStatistic> userPlayerStatsList = [];
    userPlayerStatsJson['response']['data'].forEach((item) {
      userPlayerStatsList.add(
        UserStatisticModel.fromJson(
          userStatisticType: UserStatisticType.player,
          json: item,
        ),
      );
    });

    return userPlayerStatsList;
  }
}
