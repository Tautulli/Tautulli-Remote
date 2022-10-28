part of 'metadata_bloc.dart';

abstract class MetadataEvent extends Equatable {
  const MetadataEvent();

  @override
  List<Object> get props => [];
}

class MetadataFetched extends MetadataEvent {
  final String tautulliId;
  final int ratingKey;

  const MetadataFetched({
    required this.tautulliId,
    required this.ratingKey,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey];
}
