part of 'library_media_bloc.dart';

abstract class LibraryMediaEvent extends Equatable {
  const LibraryMediaEvent();
}

class LibraryMediaFetched extends LibraryMediaEvent {
  final String tautulliId;
  final int ratingKey;
  final int sectionId;
  final SettingsBloc settingsBloc;

  LibraryMediaFetched({
    @required this.tautulliId,
    this.ratingKey,
    this.sectionId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey, sectionId, settingsBloc];
}

class LibraryMediaFullRefresh extends LibraryMediaEvent {
  final String tautulliId;
  final int ratingKey;
  final int sectionId;

  LibraryMediaFullRefresh({
    @required this.tautulliId,
    this.ratingKey,
    this.sectionId,
  });

  @override
  List<Object> get props => [tautulliId, ratingKey, sectionId];
}
