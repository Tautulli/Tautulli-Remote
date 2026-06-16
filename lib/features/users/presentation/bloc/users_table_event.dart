part of 'users_table_bloc.dart';

abstract class UsersTableEvent extends Equatable {
  const UsersTableEvent();

  @override
  List<Object> get props => [];
}

class UsersTableFetched extends UsersTableEvent {
  final ServerModel server;
  final bool? grouping;
  final String? orderColumn;
  final String? orderDir;
  final int? start;
  final int? length;
  final String? search;
  final bool freshFetch;

  const UsersTableFetched({
    required this.server,
    this.grouping,
    this.orderColumn,
    this.orderDir,
    this.start,
    this.length,
    this.search,
    this.freshFetch = false,
  });

  @override
  List<Object> get props => [server, freshFetch];
}
