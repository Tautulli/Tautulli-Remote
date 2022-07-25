part of 'library_statistics_bloc.dart';

abstract class LibraryStatisticsEvent extends Equatable {
  const LibraryStatisticsEvent();

  @override
  List<Object> get props => [];
}

class LibraryStatisticsFetched extends LibraryStatisticsEvent {
  final String tautulliId;
  final int sectionId;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const LibraryStatisticsFetched({
    required this.tautulliId,
    required this.sectionId,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, sectionId, freshFetch, settingsBloc];
}
