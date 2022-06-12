import 'package:dartz/dartz.dart';

import '../../../types/media_type.dart';
import '../connection_handler.dart';

abstract class GetRecentlyAdded {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  });
}

class GetRecentlyAddedImpl implements GetRecentlyAdded {
  final ConnectionHandler connectionHandler;

  GetRecentlyAddedImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
    required int count,
    int? start,
    MediaType? mediaType,
    int? sectionId,
  }) {
    Map<String, dynamic> params = {'count': count};
    if (start != null) params['start'] = start;
    if (mediaType != null) params['media_type'] = mediaType;
    if (sectionId != null) params['section_id'] = sectionId;

    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_recently_added',
      params: params,
    );

    return response;
  }
}
