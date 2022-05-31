import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/stream_decision.dart';
import '../../data/models/history_model.dart';
import '../repositories/history_repository.dart';

class History {
  final HistoryRepository repository;

  History({required this.repository});

  /// Returns a list of <HistoryModel>.
  Future<Either<Failure, Tuple2<List<HistoryModel>, bool>>> getHistory({
    required String tautulliId,
    bool? grouping,
    bool? includeActivity,
    String? user,
    int? userId,
    int? ratingKey,
    int? parentRatingKey,
    int? grandparentRatingKey,
    DateTime? startDate,
    DateTime? before,
    DateTime? after,
    int? sectionId,
    String? mediaType,
    StreamDecision? transcodeDecision,
    String? guid,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    return await repository.getHistory(
      tautulliId: tautulliId,
      grouping: grouping,
      includeActivity: includeActivity,
      user: user,
      userId: userId,
      ratingKey: ratingKey,
      parentRatingKey: parentRatingKey,
      grandparentRatingKey: grandparentRatingKey,
      startDate: startDate,
      before: before,
      after: after,
      sectionId: sectionId,
      mediaType: mediaType,
      transcodeDecision: transcodeDecision,
      guid: guid,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );
  }
}
