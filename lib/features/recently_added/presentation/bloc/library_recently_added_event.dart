part of 'library_recently_added_bloc.dart';

abstract class LibraryRecentlyAddedEvent extends Equatable {
  const LibraryRecentlyAddedEvent();

  @override
  List<Object> get props => [];
}

class LibraryRecentlyAddedFetched extends LibraryRecentlyAddedEvent {
  final String tautulliId;
  final int sectionId;
  final int? start;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const LibraryRecentlyAddedFetched({
    required this.tautulliId,
    required this.sectionId,
    this.start,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, sectionId, freshFetch, settingsBloc];
}
