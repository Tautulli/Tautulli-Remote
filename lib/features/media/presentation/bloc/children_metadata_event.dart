part of 'children_metadata_bloc.dart';

abstract class ChildrenMetadataEvent extends Equatable {
  const ChildrenMetadataEvent();
}

class ChildrenMetadataFetched extends ChildrenMetadataEvent {
  final String tautulliId;
  final int ratingKey;
  final String mediaType;
  final SettingsBloc settingsBloc;

  ChildrenMetadataFetched({
    @required this.tautulliId,
    @required this.ratingKey,
    this.mediaType,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey, settingsBloc];
}
