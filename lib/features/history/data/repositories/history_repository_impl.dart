import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/history.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDataSource dataSource;
  final NetworkInfo networkInfo;

  HistoryRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<History>>> getHistory({
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
    if (await networkInfo.isConnected) {
      try {
        final historyList = await dataSource.getHistory(
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
        return Right(historyList);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
