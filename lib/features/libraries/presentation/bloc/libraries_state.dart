part of 'libraries_bloc.dart';

abstract class LibrariesState extends Equatable {
  const LibrariesState();

  @override
  List<Object> get props => [];
}

class LibrariesInitial extends LibrariesState {}

class LibrariesSuccess extends LibrariesState {
  final List<Library> librariesList;
  final Map<int, String> imageMap;

  LibrariesSuccess({
    @required this.librariesList,
    @required this.imageMap,
  });

  @override
  List<Object> get props => [librariesList, imageMap];
}

class LibrariesFailure extends LibrariesState {
  final Failure failure;
  final String message;
  final String suggestion;

  LibrariesFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
