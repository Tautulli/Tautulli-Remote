part of 'libraries_bloc.dart';

abstract class LibrariesState extends Equatable {
  const LibrariesState();

  @override
  List<Object> get props => [];
}

class LibrariesInitial extends LibrariesState {}

class LibrariesSuccess extends LibrariesState {
  final Map<String, List<Library>> librariesMap;
  final Map<String, String> imageMap;
  final int librariesCount;

  LibrariesSuccess({
    @required this.librariesMap,
    @required this.imageMap,
    @required this.librariesCount,
  });

  @override
  List<Object> get props => [librariesMap, imageMap, librariesCount];
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
