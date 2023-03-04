part of 'recently_added_bloc.dart';

abstract class RecentlyAddedEvent extends Equatable {
  const RecentlyAddedEvent();

  @override
  List<Object> get props => [];
}

class RecentlyAddedFetched extends RecentlyAddedEvent {
  final ServerModel server;
  final MediaType? mediaType;
  final int? sectionId;
  final int? start;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const RecentlyAddedFetched({
    required this.server,
    this.mediaType,
    this.sectionId,
    this.start,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, freshFetch, settingsBloc];
}
