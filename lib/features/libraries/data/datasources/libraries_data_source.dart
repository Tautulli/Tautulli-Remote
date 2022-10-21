import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../../../../core/types/section_type.dart';
import '../models/library_media_info_model.dart';
import '../models/library_table_model.dart';
import '../models/library_user_stat_model.dart';
import '../models/library_watch_time_stat_model.dart';

abstract class LibrariesDataSource {
  Future<Tuple2<List<LibraryTableModel>, bool>> getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });

  Future<Tuple2<List<LibraryMediaInfoModel>, bool>> getLibraryMediaInfo({
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

  Future<Tuple2<List<LibraryUserStatModel>, bool>> getLibraryUserStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  });

  Future<Tuple2<List<LibraryWatchTimeStatModel>, bool>> getLibraryWatchTimeStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  });
}

class LibrariesDataSourceImpl implements LibrariesDataSource {
  final GetLibrariesTable getLibrariesTableApi;
  final GetLibraryMediaInfo getLibraryMediaInfoApi;
  final GetLibraryUserStats getLibraryUserStatsApi;
  final GetLibraryWatchTimeStats getLibraryWatchTimeStatsApi;

  LibrariesDataSourceImpl({
    required this.getLibrariesTableApi,
    required this.getLibraryMediaInfoApi,
    required this.getLibraryUserStatsApi,
    required this.getLibraryWatchTimeStatsApi,
  });

  @override
  Future<Tuple2<List<LibraryTableModel>, bool>> getLibrariesTable({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  }) async {
    final result = await getLibrariesTableApi(
      tautulliId: tautulliId,
      grouping: grouping,
      orderColumn: orderColumn,
      orderDir: orderDir,
      start: start,
      length: length,
      search: search,
    );

    final List<LibraryTableModel> librariesList =
        result.value1['response']['data']['data'].map<LibraryTableModel>((librariesItem) {
      LibraryTableModel library = LibraryTableModel.fromJson(librariesItem);

      if (library.live == true) {
        library = library.copyWith(sectionType: SectionType.live);
      }

      if (library.libraryThumb == '/:/resources/video.png') {
        library = library.copyWith(sectionType: SectionType.video);
      }

      return library;
    }).toList();

    return Tuple2(librariesList, result.value2);
  }

  @override
  Future<Tuple2<List<LibraryMediaInfoModel>, bool>> getLibraryMediaInfo({
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
    final result = await getLibraryMediaInfoApi(
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

    List<LibraryMediaInfoModel> libraryMediaList = [];

    for (Map<String, dynamic> data in result.value1['response']['data']['data']) {
      libraryMediaList.add(LibraryMediaInfoModel.fromJson(data));
    }

    return Tuple2(libraryMediaList, result.value2);
  }

  @override
  Future<Tuple2<List<LibraryUserStatModel>, bool>> getLibraryUserStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  }) async {
    final result = await getLibraryUserStatsApi(
      tautulliId: tautulliId,
      sectionId: sectionId,
      grouping: grouping,
    );

    final List<LibraryUserStatModel> userStatList = result.value1['response']['data']
        .map<LibraryUserStatModel>((userStat) => LibraryUserStatModel.fromJson(userStat))
        .toList();

    return Tuple2(userStatList, result.value2);
  }

  @override
  Future<Tuple2<List<LibraryWatchTimeStatModel>, bool>> getLibraryWatchTimeStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  }) async {
    final result = await getLibraryWatchTimeStatsApi(
      tautulliId: tautulliId,
      sectionId: sectionId,
      grouping: grouping,
      queryDays: queryDays,
    );

    final List<LibraryWatchTimeStatModel> watchTimeStatList = result.value1['response']['data']
        .map<LibraryWatchTimeStatModel>((watchTimeStat) => LibraryWatchTimeStatModel.fromJson(watchTimeStat))
        .toList();

    return Tuple2(watchTimeStatList, result.value2);
  }
}
