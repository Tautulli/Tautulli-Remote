part of 'history_libraries_bloc.dart';

abstract class HistoryLibrariesState extends Equatable {
  const HistoryLibrariesState();

  @override
  List<Object> get props => [];
}

class HistoryLibrariesInitial extends HistoryLibrariesState {}

class HistoryLibrariesInProgress extends HistoryLibrariesState {}

class HistoryLibrariesSuccess extends HistoryLibrariesState {
  final List<History> list;
  final bool hasReachedMax;

  HistoryLibrariesSuccess({
    @required this.list,
    @required this.hasReachedMax,
  });

  HistoryLibrariesSuccess copyWith({
    List<History> list,
    bool hasReachedMax,
  }) {
    return HistoryLibrariesSuccess(
      list: list ?? this.list,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [list, hasReachedMax];
}

class HistoryLibrariesFailure extends HistoryLibrariesState {
  final Failure failure;
  final String message;
  final String suggestion;

  HistoryLibrariesFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
