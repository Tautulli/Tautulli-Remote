part of 'user_statistics_bloc.dart';

enum UserStatisticsStatus { initial, success, failure }

class UserStatisticsState extends Equatable {
  final UserStatisticsStatus watchTimeStatsStatus;
  final UserStatisticsStatus playerStatsStatus;
  final List<UserWatchTimeStatModel> watchTimeStatsList;
  final List<UserPlayerStatModel> playerStatsList;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const UserStatisticsState({
    this.watchTimeStatsStatus = UserStatisticsStatus.initial,
    this.playerStatsStatus = UserStatisticsStatus.initial,
    this.watchTimeStatsList = const [],
    this.playerStatsList = const [],
    this.failure,
    this.message,
    this.suggestion,
  });

  UserStatisticsState copyWith({
    UserStatisticsStatus? watchTimeStatsStatus,
    UserStatisticsStatus? playerStatsStatus,
    List<UserWatchTimeStatModel>? watchTimeStatsList,
    List<UserPlayerStatModel>? playerStatsList,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return UserStatisticsState(
      watchTimeStatsStatus: watchTimeStatsStatus ?? this.watchTimeStatsStatus,
      playerStatsStatus: playerStatsStatus ?? this.playerStatsStatus,
      watchTimeStatsList: watchTimeStatsList ?? this.watchTimeStatsList,
      playerStatsList: playerStatsList ?? this.playerStatsList,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [
        watchTimeStatsStatus,
        playerStatsStatus,
        watchTimeStatsList,
        playerStatsList,
      ];
}
