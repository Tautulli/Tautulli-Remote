part of 'libraries_bloc.dart';

abstract class LibrariesState extends Equatable {
  const LibrariesState();

  @override
  List<Object> get props => [];
}

class LibrariesInitial extends LibrariesState {
  final String orderColumn;
  final String orderDir;

  LibrariesInitial({
    this.orderColumn,
    this.orderDir,
  });

  @override
  List<Object> get props => [orderColumn, orderDir];
}

class LibrariesSuccess extends LibrariesState {
  final List<Library> librariesList;

  LibrariesSuccess({
    @required this.librariesList,
  });

  @override
  List<Object> get props => [librariesList];
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
