// @dart=2.9

part of 'history_individual_bloc.dart';

abstract class HistoryIndividualState extends Equatable {
  const HistoryIndividualState();

  @override
  List<Object> get props => [];
}

class HistoryIndividualInitial extends HistoryIndividualState {}

class HistoryIndividualInProgress extends HistoryIndividualState {}

class HistoryIndividualSuccess extends HistoryIndividualState {
  final List<History> list;
  final List<UserTable> userTableList;
  final bool hasReachedMax;

  HistoryIndividualSuccess({
    @required this.list,
    @required this.hasReachedMax,
    @required this.userTableList,
  });

  HistoryIndividualSuccess copyWith({
    List<History> list,
    bool hasReachedMax,
    List<UserTable> userTableList,
  }) {
    return HistoryIndividualSuccess(
      list: list ?? this.list,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      userTableList: userTableList ?? this.userTableList,
    );
  }

  @override
  List<Object> get props => [list, hasReachedMax, userTableList];
}

class HistoryIndividualFailure extends HistoryIndividualState {
  final Failure failure;
  final String message;
  final String suggestion;

  HistoryIndividualFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
