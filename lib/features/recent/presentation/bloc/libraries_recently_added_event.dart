part of 'libraries_recently_added_bloc.dart';

abstract class LibrariesRecentlyAddedEvent extends Equatable {
  const LibrariesRecentlyAddedEvent();

  @override
  List<Object> get props => [];
}

class LibrariesRecentlyAddedFetch extends LibrariesRecentlyAddedEvent {
  final String tautulliId;
  final int sectionId;
  final SettingsBloc settingsBloc;

  LibrariesRecentlyAddedFetch({
    @required this.tautulliId,
    @required this.sectionId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, sectionId, settingsBloc];
}
