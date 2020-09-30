part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {
  final int userId;
  final String mediaType;

  HistoryInitial({
    this.userId,
    this.mediaType,
  });

  @override
  List<Object> get props => [userId, mediaType];
}

class HistorySuccess extends HistoryState {
  final List<History> list;
  final bool hasReachedMax;

  HistorySuccess({
    @required this.list,
    @required this.hasReachedMax,
  });

  HistorySuccess copyWith({
    List<History> list,
    bool hasReachedMax,
  }) {
    return HistorySuccess(
      list: list ?? this.list,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [list, hasReachedMax];
}

class HistoryFailure extends HistoryState {
  final Failure failure;
  final String message;
  final String suggestion;

  HistoryFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
