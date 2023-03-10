part of 'user_history_bloc.dart';

class UserHistoryState extends Equatable {
  final BlocStatus status;
  final List<HistoryModel> history;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const UserHistoryState({
    this.status = BlocStatus.initial,
    this.history = const [],
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  UserHistoryState copyWith({
    BlocStatus? status,
    List<HistoryModel>? history,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return UserHistoryState(
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
