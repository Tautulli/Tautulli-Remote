import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../../settings/presentation/bloc/settings_bloc.dart';

abstract class DeleteSyncedItemDataSource {
  Future<bool> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
    @required SettingsBloc settingsBloc,
  });
}

class DeleteSyncedItemDataSourceImpl implements DeleteSyncedItemDataSource {
  final tautulliApi.DeleteSyncedItem apiDeleteSyncedItem;

  DeleteSyncedItemDataSourceImpl({@required this.apiDeleteSyncedItem});

  @override
  Future<bool> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
    @required SettingsBloc settingsBloc,
  }) async {
    final deleteSyncedItemJson = await apiDeleteSyncedItem(
      tautulliId: tautulliId,
      clientId: clientId,
      syncId: syncId,
      settingsBloc: settingsBloc,
    );

    if (deleteSyncedItemJson['response']['result'] == 'success') {
      return true;
    }

    return false;
  }
}
