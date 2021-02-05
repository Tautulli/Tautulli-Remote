import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
import '../../../../core/error/exception.dart';
import '../../domain/entities/metadata_item.dart';
import '../models/metadata_item_model.dart';

abstract class MetadataDataSource {
  Future<MetadataItem> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  });
}

class MetadataDataSourceImpl implements MetadataDataSource {
  final TautulliApi tautulliApi;

  MetadataDataSourceImpl({@required this.tautulliApi});

  @override
  Future<MetadataItem> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  }) async {
    final metadataItemJson = await tautulliApi.getMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      syncId: syncId,
    );

    Map<String, dynamic> metadataMap = metadataItemJson['response']['data'];

    if (metadataMap.isEmpty) {
      throw MetadataEmptyException;
    } else {
      MetadataItem metadataItem = MetadataItemModel.fromJson(metadataMap);

      return metadataItem;
    }
  }
}
