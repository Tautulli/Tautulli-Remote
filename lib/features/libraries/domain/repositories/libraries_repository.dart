import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/section_type.dart';
import '../../data/models/library_media_info_model.dart';
import '../../data/models/library_table_model.dart';
import '../../data/models/library_user_stat_model.dart';
import '../../data/models/library_watch_time_stat_model.dart';

abstract class LibrariesRepository {
  Future<Either<Failure, Tuple2<List<LibraryTableModel>, bool>>> getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });

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
  });

  Future<Either<Failure, Tuple2<List<LibraryUserStatModel>, bool>>> getLibraryUserStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<List<LibraryWatchTimeStatModel>, bool>>> getLibraryWatchTimeStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  });
}
