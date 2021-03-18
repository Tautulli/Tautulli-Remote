import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/metadata_item.dart';
import '../repositories/metadata_repository.dart';

class GetMetadata {
  final MetadataRepository repository;

  GetMetadata({@required this.repository});

  Future<Either<Failure, MetadataItem>> call({
    @required String tautulliId,
    int ratingKey,
    int syncId,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      syncId: syncId,
      settingsBloc: settingsBloc,
    );
  }
}
