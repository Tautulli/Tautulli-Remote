import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_data_source.dart';
import '../models/history_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDataSource dataSource;
  final NetworkInfo networkInfo;

  HistoryRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getHistory(
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

        return Right(result);
      } catch (e) {
        final failure = FailureHelper.castToFailure(e);
        return Left(failure);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
