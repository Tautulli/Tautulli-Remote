import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api.dart';
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
    String tautulliId,
    int ratingKey,
    int syncId,
  }) async {
    final metadataItemJson = await tautulliApi.getMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      syncId: syncId,
    );

    MetadataItem metadataItem =
        MetadataItemModel.fromJson(metadataItemJson['response']['data']);

    return metadataItem;
  }
}
