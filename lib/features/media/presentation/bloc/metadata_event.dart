part of 'metadata_bloc.dart';

abstract class MetadataEvent extends Equatable {
  const MetadataEvent();

  @override
  List<Object> get props => [];
}

class MetadataFetched extends MetadataEvent {
  final String tautulliId;
  final int ratingKey;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const MetadataFetched({
    required this.tautulliId,
    required this.ratingKey,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey, freshFetch, settingsBloc];
}
