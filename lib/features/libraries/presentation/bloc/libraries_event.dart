// @dart=2.9

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
  final SettingsBloc settingsBloc;

  LibrariesFetch({
    @required this.tautulliId,
    @required this.orderColumn,
    @required this.orderDir,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, orderColumn, orderDir, settingsBloc];
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
