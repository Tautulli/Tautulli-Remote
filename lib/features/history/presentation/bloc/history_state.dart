part of 'history_bloc.dart';

class HistoryState extends Equatable {
  final BlocStatus status;
  final List<HistoryModel> history;
  final int? userId;
  final bool movieMediaType;
  final bool episodeMediaType;
  final bool trackMediaType;
  final bool liveMediaType;
  final bool directPlayDecision;
  final bool directStreamDecision;
  final bool transcodeDecision;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const HistoryState({
    this.status = BlocStatus.initial,
    this.history = const [],
    this.userId,
    this.movieMediaType = false,
    this.episodeMediaType = false,
    this.trackMediaType = false,
    this.liveMediaType = false,
    this.directPlayDecision = false,
    this.directStreamDecision = false,
    this.transcodeDecision = false,
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  HistoryState copyWith({
    BlocStatus? status,
    List<HistoryModel>? history,
    int? userId,
    bool? movieMediaType,
    bool? episodeMediaType,
    bool? trackMediaType,
    bool? liveMediaType,
    bool? directPlayDecision,
    bool? directStreamDecision,
    bool? transcodeDecision,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return HistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      userId: userId ?? this.userId,
      movieMediaType: movieMediaType ?? this.movieMediaType,
      episodeMediaType: episodeMediaType ?? this.episodeMediaType,
      trackMediaType: trackMediaType ?? this.trackMediaType,
      liveMediaType: liveMediaType ?? this.liveMediaType,
      directPlayDecision: directPlayDecision ?? this.directPlayDecision,
      directStreamDecision: directStreamDecision ?? this.directStreamDecision,
      transcodeDecision: transcodeDecision ?? this.transcodeDecision,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        status,
        history,
        movieMediaType,
        episodeMediaType,
        trackMediaType,
        liveMediaType,
        directPlayDecision,
        directStreamDecision,
        transcodeDecision,
        hasReachedMax,
      ];
}
