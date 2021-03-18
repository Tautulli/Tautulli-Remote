import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/metadata_item.dart';

abstract class ChildrenMetadataRepository {
  Future<Either<Failure, List<MetadataItem>>> getChildrenMetadata({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
    @required SettingsBloc settingsBloc,
  });
}
