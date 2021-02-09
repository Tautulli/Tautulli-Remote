part of 'children_metadata_bloc.dart';

abstract class ChildrenMetadataEvent extends Equatable {
  const ChildrenMetadataEvent();
}

class ChildrenMetadataFetched extends ChildrenMetadataEvent {
  final String tautulliId;
  final int ratingKey;

  ChildrenMetadataFetched({
    @required this.tautulliId,
    @required this.ratingKey,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey];
}
