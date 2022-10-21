import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/types/section_type.dart';
import '../../domain/repositories/libraries_repository.dart';
import '../datasources/libraries_data_source.dart';
import '../models/library_media_info_model.dart';
import '../models/library_table_model.dart';
import '../models/library_user_stat_model.dart';
import '../models/library_watch_time_stat_model.dart';

class LibrariesRepositoryImpl implements LibrariesRepository {
  final LibrariesDataSource dataSource;
  final NetworkInfo networkInfo;

  LibrariesRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Tuple2<List<LibraryTableModel>, bool>>> getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getLibrariesTable(
          tautulliId: tautulliId,
          grouping: grouping,
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

  @override
  Future<Either<Failure, Tuple2<List<LibraryMediaInfoModel>, bool>>> getLibraryMediaInfo({
    required String tautulliId,
    required int sectionId,
    int? ratingKey,
    SectionType? sectionType,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
    bool? refresh,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getLibraryMediaInfo(
          tautulliId: tautulliId,
          sectionId: sectionId,
          ratingKey: ratingKey,
          sectionType: sectionType,
          orderColumn: orderColumn,
          orderDir: orderDir,
          start: start,
          length: length,
          search: search,
          refresh: refresh,
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

  @override
  Future<Either<Failure, Tuple2<List<LibraryUserStatModel>, bool>>> getLibraryUserStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getLibraryUserStats(
          tautulliId: tautulliId,
          sectionId: sectionId,
          grouping: grouping,
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

  @override
  Future<Either<Failure, Tuple2<List<LibraryWatchTimeStatModel>, bool>>> getLibraryWatchTimeStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getLibraryWatchTimeStats(
          tautulliId: tautulliId,
          sectionId: sectionId,
          grouping: grouping,
          queryDays: queryDays,
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
