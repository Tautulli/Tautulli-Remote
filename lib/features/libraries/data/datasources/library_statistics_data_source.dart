// @dart=2.9

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library_statistic.dart';
import '../models/library_statistic_model.dart';

abstract class LibraryStatisticsDataSource {
  Future<List> getLibraryWatchTimeStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  });
  Future<List> getLibraryUserStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  });
}

class LibraryStatisticsDataSourceImpl implements LibraryStatisticsDataSource {
  final tautulli_api.GetLibraryWatchTimeStats apiGetLibraryWatchTimeStats;
  final tautulli_api.GetLibraryUserStats apiGetLibraryUserStats;

  LibraryStatisticsDataSourceImpl({
    @required this.apiGetLibraryWatchTimeStats,
    @required this.apiGetLibraryUserStats,
  });

  @override
  Future<List> getLibraryWatchTimeStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    final libraryWatchTimeStatsJson = await apiGetLibraryWatchTimeStats(
      tautulliId: tautulliId,
      sectionId: sectionId,
      settingsBloc: settingsBloc,
    );

    final List<LibraryStatistic> libraryWatchTimeStatsList = [];
    libraryWatchTimeStatsJson['response']['data'].forEach((item) {
      libraryWatchTimeStatsList.add(
        LibraryStatisticModel.fromJson(
          libraryStatisticType: LibraryStatisticType.watchTime,
          json: item,
        ),
      );
    });

    return libraryWatchTimeStatsList;
  }

  @override
  Future<List> getLibraryUserStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    final libraryUserStatsJson = await apiGetLibraryUserStats(
      tautulliId: tautulliId,
      sectionId: sectionId,
      settingsBloc: settingsBloc,
    );

    final List<LibraryStatistic> libraryUserStatsList = [];
    libraryUserStatsJson['response']['data'].forEach((item) {
      libraryUserStatsList.add(
        LibraryStatisticModel.fromJson(
          libraryStatisticType: LibraryStatisticType.user,
          json: item,
        ),
      );
    });

    return libraryUserStatsList;
  }
}
