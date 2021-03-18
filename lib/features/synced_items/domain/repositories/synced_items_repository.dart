import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/synced_item.dart';

abstract class SyncedItemsRepository {
  Future<Either<Failure, List<SyncedItem>>> getSyncedItems({
    @required String tautulliId,
    int userId,
    @required SettingsBloc settingsBloc,
  });
}
