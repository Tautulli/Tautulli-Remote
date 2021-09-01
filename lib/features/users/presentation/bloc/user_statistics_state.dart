// @dart=2.9

part of 'user_statistics_bloc.dart';

abstract class UserStatisticsState extends Equatable {
  const UserStatisticsState();

  @override
  List<Object> get props => [];
}

class UserStatisticsInitial extends UserStatisticsState {}

class UserStatisticsInProgress extends UserStatisticsState {}

class UserStatisticsSuccess extends UserStatisticsState {
  final List<UserStatistic> watchTimeStatsList;
  final List<UserStatistic> playerStatsList;

  UserStatisticsSuccess({
    @required this.watchTimeStatsList,
    @required this.playerStatsList,
  });

  @override
  List<Object> get props => [watchTimeStatsList, playerStatsList];
}

class UserStatisticsFailure extends UserStatisticsState {
  final Failure failure;
  final String message;
  final String suggestion;

  UserStatisticsFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
