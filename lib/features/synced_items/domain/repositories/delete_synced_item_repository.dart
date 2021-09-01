// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

abstract class DeleteSyncedItemRepository {
  Future<Either<Failure, bool>> call({
    @required String tautulliId,
    @required String clientId,
    @required int syncId,
    @required SettingsBloc settingsBloc,
  });
}
