part of 'metadata_bloc.dart';

abstract class MetadataEvent extends Equatable {
  const MetadataEvent();

  @override
  List<Object> get props => [];
}

class MetadataFetched extends MetadataEvent {
  final ServerModel server;
  final int ratingKey;
  final bool freshFetch;

  const MetadataFetched({
    required this.server,
    required this.ratingKey,
    this.freshFetch = false,
  });

  @override
  List<Object> get props => [server, ratingKey, freshFetch];
}
