import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/metadata_item.dart';
import '../repositories/children_metadata_repository.dart';

class GetChildrenMetadata {
  final ChildrenMetadataRepository repository;

  GetChildrenMetadata({@required this.repository});

  Future<Either<Failure, List<MetadataItem>>> call({
    @required String tautulliId,
    @required int ratingKey,
    String mediaType,
  }) async {
    return await repository.getChildrenMetadata(
      tautulliId: tautulliId,
      ratingKey: ratingKey,
      mediaType: mediaType,
    );
  }
}
