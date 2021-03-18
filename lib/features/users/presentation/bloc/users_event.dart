part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersFetch extends UsersEvent {
  final String tautulliId;
  final int grouping;
  final String orderColumn;
  final String orderDir;
  final int start;
  final int length;
  final String search;
  final SettingsBloc settingsBloc;

  UsersFetch({
    @required this.tautulliId,
    this.grouping,
    this.orderColumn,
    this.orderDir,
    this.start,
    this.length,
    this.search,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        tautulliId,
        grouping,
        orderColumn,
        orderDir,
        start,
        length,
        search,
        settingsBloc,
      ];
}

class UsersFilter extends UsersEvent {
  final String tautulliId;
  final int grouping;
  final String orderColumn;
  final String orderDir;
  final int start;
  final int length;
  final String search;

  UsersFilter({
    @required this.tautulliId,
    this.grouping,
    this.orderColumn,
    this.orderDir,
    this.start,
    this.length,
    this.search,
  });

  @override
  List<Object> get props => [
        tautulliId,
        grouping,
        orderColumn,
        orderDir,
        start,
        length,
        search,
      ];
}
