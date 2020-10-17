import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/metadata_item.dart';

abstract class MetadataRepository {
  Future<Either<Failure, MetadataItem>> getMetadata({
    @required String tautulliId,
    int ratingKey,
    int syncId,
  });
}
