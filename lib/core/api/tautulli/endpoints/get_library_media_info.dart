import 'package:dartz/dartz.dart';

import '../../../types/section_type.dart';
import '../connection_handler.dart';

abstract class GetLibraryMediaInfo {
  Future<Tuple2<dynamic, bool>> call({
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
}

class GetLibraryMediaInfoImpl implements GetLibraryMediaInfo {
  final ConnectionHandler connectionHandler;

  GetLibraryMediaInfoImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
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
  }) {
    Map<String, dynamic> params = {'section_id': sectionId};

    if (ratingKey != null) params['rating_key'] = ratingKey;
    if (sectionType != null) params['section_type'] = sectionType;
    if (orderColumn != null) params['order_column'] = orderColumn;
    if (orderDir != null) params['order_dir'] = orderDir;
    if (start != null) params['start'] = start;
    if (length != null) params['length'] = length;
    if (search != null) params['search'] = search;
    if (refresh != null) params['refresh'] = refresh;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_library_media_info',
      params: params,
    );

    return response;
  }
}
