// ignore_for_file: use_null_aware_elements

import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
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
  final TautulliConnectionAdapter adapter;

  LibrariesDataSourceImpl({required this.adapter});

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
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_libraries_table', params: {
        if (grouping != null) 'grouping': grouping ? 1 : 0,
        if (orderColumn != null) 'order_column': orderColumn,
        if (orderDir != null) 'order_dir': orderDir,
        if (start != null) 'start': start,
        if (length != null) 'length': length,
        if (search != null) 'search': search,
      }),
    );

    final List<LibraryTableModel> librariesList =
        result.data['data']['data'].map<LibraryTableModel>((item) {
      LibraryTableModel library = LibraryTableModel.fromJson(item);

      if (library.live == true) {
        library = library.copyWith(sectionType: SectionType.live);
      }

      if (library.libraryThumb == '/:/resources/video.png') {
        library = library.copyWith(sectionType: SectionType.video);
      }

      return library;
    }).toList();

    return Tuple2(librariesList, result.primaryActive);
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
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_library_media_info', params: {
        'section_id': sectionId,
        if (ratingKey != null) 'rating_key': ratingKey,
        if (sectionType != null) 'section_type': sectionType.value,
        if (orderColumn != null) 'order_column': orderColumn,
        if (orderDir != null) 'order_dir': orderDir,
        if (start != null) 'start': start,
        if (length != null) 'length': length,
        if (search != null) 'search': search,
        if (refresh != null) 'refresh': refresh ? 1 : 0,
      }),
    );

    final List<LibraryMediaInfoModel> libraryMediaList = [];
    for (final data in result.data['data']['data']) {
      libraryMediaList.add(LibraryMediaInfoModel.fromJson(data));
    }

    return Tuple2(libraryMediaList, result.primaryActive);
  }

  @override
  Future<Tuple2<List<LibraryUserStatModel>, bool>> getLibraryUserStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_library_user_stats', params: {
        'section_id': sectionId,
        if (grouping != null) 'grouping': grouping ? 1 : 0,
      }),
    );

    final List<LibraryUserStatModel> userStatList = result.data['data']
        .map<LibraryUserStatModel>((item) => LibraryUserStatModel.fromJson(item))
        .toList();

    return Tuple2(userStatList, result.primaryActive);
  }

  @override
  Future<Tuple2<List<LibraryWatchTimeStatModel>, bool>> getLibraryWatchTimeStats({
    required String tautulliId,
    required int sectionId,
    bool? grouping,
    String? queryDays,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_library_watch_time_stats', params: {
        'section_id': sectionId,
        if (grouping != null) 'grouping': grouping ? 1 : 0,
        if (queryDays != null) 'query_days': queryDays,
      }),
    );

    final List<LibraryWatchTimeStatModel> watchTimeStatList = result.data['data']
        .map<LibraryWatchTimeStatModel>((item) => LibraryWatchTimeStatModel.fromJson(item))
        .toList();

    return Tuple2(watchTimeStatList, result.primaryActive);
  }
}
