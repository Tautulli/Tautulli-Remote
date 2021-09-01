// @dart=2.9

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import '../../../../core/error/exception.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/metadata_item.dart';
import '../models/metadata_item_model.dart';

abstract class MetadataDataSource {
  Future<MetadataItem> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
    @required SettingsBloc settingsBloc,
  });
}

class MetadataDataSourceImpl implements MetadataDataSource {
  final tautulli_api.GetMetadata apiGetMetadata;

  MetadataDataSourceImpl({@required this.apiGetMetadata});

  @override
  Future<MetadataItem> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
    @required SettingsBloc settingsBloc,
  }) async {
    final metadataItemJson = await apiGetMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      syncId: syncId,
      settingsBloc: settingsBloc,
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
