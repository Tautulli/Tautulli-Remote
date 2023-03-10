part of 'search_history_bloc.dart';

abstract class SearchHistoryEvent extends Equatable {
  const SearchHistoryEvent();

  @override
  List<Object> get props => [];
}

class SearchHistoryFetched extends SearchHistoryEvent {
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
  final int? sectionId;
  final bool movieMediaType;
  final bool episodeMediaType;
  final bool trackMediaType;
  final bool liveMediaType;
  final bool directPlayDecision;
  final bool directStreamDecision;
  final bool transcodeDecision;
  final String? guid;
  final String? orderColumn;
  final String? orderDir;
  final int? start;
  final int? length;
  final String? search;
  final bool freshFetch;
  final SettingsBloc settingsBloc;

  const SearchHistoryFetched({
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
    this.sectionId,
    required this.movieMediaType,
    required this.episodeMediaType,
    required this.trackMediaType,
    required this.liveMediaType,
    required this.directPlayDecision,
    required this.directStreamDecision,
    required this.transcodeDecision,
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
  List<Object> get props => [
        server,
        movieMediaType,
        episodeMediaType,
        trackMediaType,
        liveMediaType,
        directPlayDecision,
        directStreamDecision,
        transcodeDecision,
        freshFetch,
        settingsBloc,
      ];
}

class SearchHistoryClear extends SearchHistoryEvent {}
