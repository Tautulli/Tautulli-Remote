part of 'history_bloc.dart';

class HistoryState extends Equatable {
  final BlocStatus status;
  final List<HistoryModel> history;
  final int? userId;
  final String mediaType;
  final String transcodeDecision;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const HistoryState({
    this.status = BlocStatus.initial,
    this.history = const [],
    this.userId,
    this.mediaType = 'all',
    this.transcodeDecision = 'all',
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  HistoryState copyWith({
    BlocStatus? status,
    List<HistoryModel>? history,
    int? userId,
    String? mediaType,
    String? transcodeDecision,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return HistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      userId: userId ?? this.userId,
      mediaType: mediaType ?? this.mediaType,
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
        mediaType,
        transcodeDecision,
        hasReachedMax,
      ];
}
