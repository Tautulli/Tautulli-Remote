part of 'libraries_recently_added_bloc.dart';

abstract class LibrariesRecentlyAddedState extends Equatable {
  const LibrariesRecentlyAddedState();

  @override
  List<Object> get props => [];
}

class LibrariesRecentlyAddedInitial extends LibrariesRecentlyAddedState {}

class LibrariesRecentlyAddedSuccess extends LibrariesRecentlyAddedState {
  final List<RecentItem> list;
  final bool hasReachedMax;

  LibrariesRecentlyAddedSuccess({
    @required this.list,
    @required this.hasReachedMax,
  });

  LibrariesRecentlyAddedSuccess copyWith({
    List<RecentItem> list,
    bool hasReachedMax,
  }) {
    return LibrariesRecentlyAddedSuccess(
      list: list ?? this.list,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [list, hasReachedMax];
}

class LibrariesRecentlyAddedFailure extends LibrariesRecentlyAddedState {
  final Failure failure;
  final String message;
  final String suggestion;

  LibrariesRecentlyAddedFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
