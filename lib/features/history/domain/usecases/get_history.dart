import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/history.dart';
import '../repositories/history_repository.dart';

class GetHistory {
  final HistoryRepository repository;

  GetHistory({@required this.repository});

  Future<Either<Failure, List<History>>> call({
    @required String tautulliId,
    int grouping,
    String user,
    int userId,
    int ratingKey,
    int parentRatingKey,
    int grandparentRatingKey,
    String startDate,
    int sectionId,
    String mediaType,
    String transcodeDecision,
    String guid,
    String orderColumn,
    String orderDir,
    int start,
    int length,
    String search,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getHistory(
      tautulliId: tautulliId,
      grouping: grouping,
      user: user,
      userId: userId,
      ratingKey: ratingKey,
      parentRatingKey: parentRatingKey,
      grandparentRatingKey: grandparentRatingKey,
      startDate: startDate,
      sectionId: sectionId,
      mediaType: mediaType,
      transcodeDecision: transcodeDecision,
      guid: guid,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
      settingsBloc: settingsBloc,
    );
  }
}
