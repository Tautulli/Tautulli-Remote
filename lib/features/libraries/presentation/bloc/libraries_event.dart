part of 'libraries_bloc.dart';

abstract class LibrariesEvent extends Equatable {
  const LibrariesEvent();

  @override
  List<Object> get props => [];
}

class LibrariesFetch extends LibrariesEvent {
  final String tautulliId;
  final String orderColumn;
  final String orderDir;

  LibrariesFetch({
    @required this.tautulliId,
    @required this.orderColumn,
    @required this.orderDir,
  });

  @override
  List<Object> get props => [tautulliId, orderColumn, orderDir];
}

class LibrariesFilter extends LibrariesEvent {
  final String tautulliId;
  final String orderColumn;
  final String orderDir;

  LibrariesFilter({
    @required this.tautulliId,
    @required this.orderColumn,
    @required this.orderDir,
  });

  @override
  List<Object> get props => [tautulliId, orderColumn, orderDir];
}
