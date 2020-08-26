part of 'libraries_bloc.dart';

abstract class LibrariesEvent extends Equatable {
  const LibrariesEvent();

  @override
  List<Object> get props => [];
}

class LibrariesFetch extends LibrariesEvent {
  final String tautulliId;

  LibrariesFetch({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}

class LibrariesFilter extends LibrariesEvent {
  final String tautulliId;

  LibrariesFilter({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}
