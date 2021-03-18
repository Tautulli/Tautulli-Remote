import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/library_media.dart';

abstract class LibraryMediaRepository {
  Future<Either<Failure, List<LibraryMedia>>> getLibraryMediaInfo({
    @required String tautulliId,
    int ratingKey,
    int sectionId,
    String orderDir,
    int start,
    int length,
    bool refresh,
    int timeoutOverride,
    @required SettingsBloc settingsBloc,
  });
}
