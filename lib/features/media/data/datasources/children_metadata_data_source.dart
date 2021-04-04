import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/metadata_item.dart';
import '../models/metadata_item_model.dart';

abstract class ChildrenMetadataDataSource {
  Future<List<MetadataItem>> getChildrenMetadata({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
    @required SettingsBloc settingsBloc,
  });
}

class ChildrenMetadataDataSourceImpl implements ChildrenMetadataDataSource {
  final tautulli_api.GetChildrenMetadata apiGetChildrenMetadata;

  ChildrenMetadataDataSourceImpl({@required this.apiGetChildrenMetadata});

  @override
  Future<List<MetadataItem>> getChildrenMetadata({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
    @required SettingsBloc settingsBloc,
  }) async {
    final childrenMetadataInfoJson = await apiGetChildrenMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      mediaType: mediaType,
      settingsBloc: settingsBloc,
    );

    List childrenMetadataInfoMap =
        childrenMetadataInfoJson['response']['data']['children_list'];

    final List<MetadataItem> childrenMetadataList = [];

    childrenMetadataInfoMap.forEach((item) {
      if (item['title'] != 'All epsiodes' && isNotEmpty(item['media_type'])) {
        childrenMetadataList.add(MetadataItemModel.fromJson(item));
      }
    });

    return childrenMetadataList;
  }
}
