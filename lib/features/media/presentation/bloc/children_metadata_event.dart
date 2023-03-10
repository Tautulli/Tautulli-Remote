part of 'children_metadata_bloc.dart';

abstract class ChildrenMetadataEvent extends Equatable {
  const ChildrenMetadataEvent();

  @override
  List<Object> get props => [];
}

class ChildrenMetadataFetched extends ChildrenMetadataEvent {
  final ServerModel server;
  final int ratingKey;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const ChildrenMetadataFetched({
    required this.server,
    required this.ratingKey,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, ratingKey, freshFetch, settingsBloc];
}
