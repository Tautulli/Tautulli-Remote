// @dart=2.9

part of 'metadata_bloc.dart';

abstract class MetadataEvent extends Equatable {
  const MetadataEvent();
}

class MetadataFetched extends MetadataEvent {
  final String tautulliId;
  final int ratingKey;
  final int syncId;
  final SettingsBloc settingsBloc;

  MetadataFetched({
    @required this.tautulliId,
    this.ratingKey,
    this.syncId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey, syncId, settingsBloc];
}
