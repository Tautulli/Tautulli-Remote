part of 'recently_added_bloc.dart';

abstract class RecentlyAddedState extends Equatable {
  const RecentlyAddedState();
}

class RecentlyAddedInitial extends RecentlyAddedState {
  @override
  List<Object> get props => [];
}

class RecentlyAddedSuccess extends RecentlyAddedState {
  final List<RecentItem> list;
  final bool hasReachedMax;

  RecentlyAddedSuccess({
    @required this.list,
    @required this.hasReachedMax,
  });

  RecentlyAddedSuccess copyWith({
    List<RecentItem> list,
    bool hasReachedMax,
  }) {
    return RecentlyAddedSuccess(
      list: list ?? this.list,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [list, hasReachedMax];
}

class RecentlyAddedFailure extends RecentlyAddedState {
  final Failure failure;
  final String message;
  final String suggestion;

  RecentlyAddedFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
