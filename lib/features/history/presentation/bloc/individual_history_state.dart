part of 'individual_history_bloc.dart';

class IndividualHistoryState extends Equatable {
  final BlocStatus status;
  final List<HistoryModel> history;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const IndividualHistoryState({
    this.status = BlocStatus.initial,
    this.history = const [],
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  IndividualHistoryState copyWith({
    BlocStatus? status,
    List<HistoryModel>? history,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return IndividualHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, history, hasReachedMax];
}
