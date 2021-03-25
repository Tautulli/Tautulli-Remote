import 'package:meta/meta.dart';

import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/user_statistic.dart';

class UserStatisticModel extends UserStatistic {
  UserStatisticModel({
    UserStatisticType userStatisticType,
    String platform,
    String platformName,
    String playerName,
    int resultId,
    int totalPlays,
    int queryDays,
    int totalTime,
  }) : super(
          userStatisticType: userStatisticType,
          platform: platform,
          platformName: platformName,
          playerName: playerName,
          resultId: resultId,
          totalPlays: totalPlays,
          queryDays: queryDays,
          totalTime: totalTime,
        );

  factory UserStatisticModel.fromJson({
    @required UserStatisticType userStatisticType,
    @required Map<String, dynamic> json,
  }) {
    return UserStatisticModel(
      userStatisticType: userStatisticType,
      platform: ValueHelper.cast(
        value: json['platform'],
        type: CastType.string,
      ),
      platformName: ValueHelper.cast(
        value: json['platform_name'],
        type: CastType.string,
      ),
      playerName: ValueHelper.cast(
        value: json['player_name'],
        type: CastType.string,
      ),
      queryDays: ValueHelper.cast(
        value: json['query_days'],
        type: CastType.int,
      ),
      resultId: ValueHelper.cast(
        value: json['result_id'],
        type: CastType.int,
      ),
      totalPlays: ValueHelper.cast(
        value: json['total_plays'],
        type: CastType.int,
      ),
      totalTime: ValueHelper.cast(
        value: json['total_time'],
        type: CastType.int,
      ),
    );
  }
}
