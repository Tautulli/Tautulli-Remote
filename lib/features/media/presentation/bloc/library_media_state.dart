part of 'library_media_bloc.dart';

abstract class LibraryMediaState extends Equatable {
  const LibraryMediaState();

  @override
  List<Object> get props => [];
}

class LibraryMediaInitial extends LibraryMediaState {}

class LibraryMediaInProgress extends LibraryMediaState {}

class LibraryMediaSuccess extends LibraryMediaState {
  final List<LibraryMedia> libraryMediaList;
  final bool hasReachedMax;

  LibraryMediaSuccess({
    @required this.libraryMediaList,
    @required this.hasReachedMax,
  });

  LibraryMediaSuccess copyWith({
    List<LibraryMedia> libraryMediaList,
    bool hasReachedMax,
  }) {
    return LibraryMediaSuccess(
      libraryMediaList: libraryMediaList ?? this.libraryMediaList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [libraryMediaList, hasReachedMax];
}

class LibraryMediaFailure extends LibraryMediaState {
  final Failure failure;
  final String message;
  final String suggestion;

  LibraryMediaFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
