part of 'library_statistics_bloc.dart';

abstract class LibraryStatisticsEvent extends Equatable {
  const LibraryStatisticsEvent();

  @override
  List<Object> get props => [];
}

class LibraryStatisticsFetched extends LibraryStatisticsEvent {
  final ServerModel server;
  final int sectionId;
  final bool freshFetch;

  const LibraryStatisticsFetched({
    required this.server,
    required this.sectionId,
    this.freshFetch = false,
  });

  @override
  List<Object> get props => [server, sectionId, freshFetch];
}
