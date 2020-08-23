part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistorySuccess extends HistoryState {
  final List<History> list;
  final List<User> usersList;
  final bool hasReachedMax;

  HistorySuccess({
    @required this.list,
    @required this.usersList,
    @required this.hasReachedMax,
  });

  HistorySuccess copyWith({
    List<History> list,
    List<User> usersList,
    bool hasReachedMax,
  }) {
    return HistorySuccess(
      list: list ?? this.list,
      usersList: usersList ?? this.usersList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [list, usersList, hasReachedMax];
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
