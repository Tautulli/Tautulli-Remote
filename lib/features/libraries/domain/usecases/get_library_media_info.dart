import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/library_media.dart';
import '../repositories/library_media_repository.dart';

class GetLibraryMediaInfo {
  final LibraryMediaRepository repository;

  GetLibraryMediaInfo({@required this.repository});

  Future<Either<Failure, List<LibraryMedia>>> call({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir = 'asc',
    int start,
    int length,
    bool refresh,
    int timeoutOverride,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getLibraryMediaInfo(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      sectionId: sectionId,
      orderDir: orderDir,
      start: start,
      length: length,
      refresh: refresh,
      timeoutOverride: timeoutOverride,
      settingsBloc: settingsBloc,
    );
  }
}
