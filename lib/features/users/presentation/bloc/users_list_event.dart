part of 'users_list_bloc.dart';

abstract class UsersListEvent extends Equatable {
  const UsersListEvent();

  @override
  List<Object> get props => [];
}

class UsersListFetch extends UsersListEvent {
  final String tautulliId;

  UsersListFetch({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}
