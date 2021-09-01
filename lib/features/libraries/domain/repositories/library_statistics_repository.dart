// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/library_statistic.dart';

abstract class LibraryStatisticsRepository {
  Future<Either<Failure, List<LibraryStatistic>>> getLibraryWatchTimeStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  });
  Future<Either<Failure, List<LibraryStatistic>>> getLibraryUserStats({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  });
}
