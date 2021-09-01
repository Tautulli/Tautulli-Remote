// @dart=2.9

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum UserStatisticType {
  watchTime,
  player,
}

class UserStatistic extends Equatable {
  final UserStatisticType userStatisticType;
  final String platform;
  final String platformName;
  final String playerName;
  final int resultId;
  final int totalPlays;
  final int queryDays;
  final int totalTime;

  UserStatistic({
    @required this.userStatisticType,
    this.platform,
    this.platformName,
    this.playerName,
    this.resultId,
    this.totalPlays,
    this.queryDays,
    this.totalTime,
  });

  @override
  List<Object> get props => [
        userStatisticType,
        platform,
        platformName,
        playerName,
        resultId,
        totalPlays,
        queryDays,
        totalTime,
      ];
}
