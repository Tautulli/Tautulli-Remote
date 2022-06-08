import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/history_model.dart';

abstract class HistoryRepository {
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
    String? transcodeDecision,
    String? guid,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });
}
