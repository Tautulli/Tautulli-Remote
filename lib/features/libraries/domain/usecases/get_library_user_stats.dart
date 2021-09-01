// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/library_statistic.dart';
import '../repositories/library_statistics_repository.dart';

class GetLibraryUserStats {
  final LibraryStatisticsRepository repository;

  GetLibraryUserStats({@required this.repository});

  Future<Either<Failure, List<LibraryStatistic>>> call({
    @required String tautulliId,
    @required int sectionId,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getLibraryUserStats(
      tautulliId: tautulliId,
      sectionId: sectionId,
      settingsBloc: settingsBloc,
    );
  }
}
