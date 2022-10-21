import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/section_type.dart';
import '../../data/models/library_media_info_model.dart';
import '../../data/models/library_table_model.dart';
import '../../data/models/library_user_stat_model.dart';
import '../../data/models/library_watch_time_stat_model.dart';
import '../repositories/libraries_repository.dart';

class Libraries {
  final LibrariesRepository repository;

  Libraries({required this.repository});

  /// Returns a list of <LibrariesTableModel>.
  Future<Either<Failure, Tuple2<List<LibraryTableModel>, bool>>> getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    return await repository.getLibrariesTable(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );
  }

  /// Returns a list of `LibraryMediaInfoModel` for the library with the provided `sectionId`.
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
    return await repository.getLibraryMediaInfo(
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
  }

  /// Returns a list of library user stats for the library with the provided `sectionId`.
  Future<Either<Failure, Tuple2<List<LibraryUserStatModel>, bool>>> getLibraryUserStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  }) async {
    return await repository.getLibraryUserStats(
      tautulliId: tautulliId,
      sectionId: sectionId,
      grouping: grouping,
    );
  }

  /// Returns a list of watch time stats for the library with the provided `sectionId`.
  Future<Either<Failure, Tuple2<List<LibraryWatchTimeStatModel>, bool>>> getLibraryWatchTimeStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  }) async {
    return await repository.getLibraryWatchTimeStats(
      tautulliId: tautulliId,
      sectionId: sectionId,
      grouping: grouping,
      queryDays: queryDays,
    );
  }
}
