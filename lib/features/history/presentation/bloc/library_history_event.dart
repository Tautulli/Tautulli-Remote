part of 'library_history_bloc.dart';

abstract class LibraryHistoryEvent extends Equatable {
  const LibraryHistoryEvent();

  @override
  List<Object> get props => [];
}

class LibraryHistoryFetched extends LibraryHistoryEvent {
  final ServerModel server;
  final bool? grouping;
  final bool? includeActivity;
  final String? user;
  final int? userId;
  final int? ratingKey;
  final int? parentRatingKey;
  final int? grandparentRatingKey;
  final DateTime? startDate;
  final DateTime? before;
  final DateTime? after;
  final int sectionId;
  final String? mediaType;
  final String? transcodeDecision;
  final String? guid;
  final String? orderColumn;
  final String? orderDir;
  final int? start;
  final int? length;
  final String? search;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const LibraryHistoryFetched({
    required this.server,
    this.grouping,
    this.includeActivity,
    this.user,
    this.userId,
    this.ratingKey,
    this.parentRatingKey,
    this.grandparentRatingKey,
    this.startDate,
    this.before,
    this.after,
    required this.sectionId,
    this.mediaType,
    this.transcodeDecision,
    this.guid,
    this.orderColumn,
    this.orderDir,
    this.start,
    this.length,
    this.search,
    this.freshFetch = false,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, freshFetch, settingsBloc];
}
