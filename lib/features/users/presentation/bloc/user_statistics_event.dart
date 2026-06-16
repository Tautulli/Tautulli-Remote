part of 'user_statistics_bloc.dart';

abstract class UserStatisticsEvent extends Equatable {
  const UserStatisticsEvent();

  @override
  List<Object> get props => [];
}

class UserStatisticsFetched extends UserStatisticsEvent {
  final ServerModel server;
  final int userId;
  final bool freshFetch;

  const UserStatisticsFetched({
    required this.server,
    required this.userId,
    this.freshFetch = false,
  });

  @override
  List<Object> get props => [server, userId, freshFetch];
}
