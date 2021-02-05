part of 'metadata_bloc.dart';

abstract class MetadataEvent extends Equatable {
  const MetadataEvent();
}

class MetadataFetched extends MetadataEvent {
  final String tautulliId;
  final int ratingKey;
  final int syncId;

  MetadataFetched({
    @required this.tautulliId,
    this.ratingKey,
    this.syncId,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey, syncId];
}
