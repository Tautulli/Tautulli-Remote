part of 'history_users_bloc.dart';

abstract class HistoryUsersEvent extends Equatable {
  const HistoryUsersEvent();

  @override
  List<Object> get props => [];
}

class HistoryUsersFetch extends HistoryUsersEvent {
  final String tautulliId;

  HistoryUsersFetch({@required this.tautulliId});

  @override
  List<Object> get props => [tautulliId];
}
