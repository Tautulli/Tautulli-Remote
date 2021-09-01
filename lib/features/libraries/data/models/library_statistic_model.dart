// @dart=2.9

import 'package:tautulli_remote/core/helpers/value_helper.dart';
import 'package:tautulli_remote/features/libraries/domain/entities/library_statistic.dart';
import 'package:meta/meta.dart';

class LibraryStatisticModel extends LibraryStatistic {
  LibraryStatisticModel({
    LibraryStatisticType libraryStatisticType,
    String friendlyName,
    int queryDays,
    int totalPlays,
    int totalTime,
    int userId,
    String username,
    String userThumb,
  }) : super(
          libraryStatisticType: libraryStatisticType,
          friendlyName: friendlyName,
          queryDays: queryDays,
          totalPlays: totalPlays,
          totalTime: totalTime,
          userId: userId,
          username: username,
          userThumb: userThumb,
        );

  factory LibraryStatisticModel.fromJson({
    @required LibraryStatisticType libraryStatisticType,
    @required Map<String, dynamic> json,
  }) {
    return LibraryStatisticModel(
      libraryStatisticType: libraryStatisticType,
      friendlyName: ValueHelper.cast(
        value: json['friendly_name'],
        type: CastType.string,
      ),
      queryDays: ValueHelper.cast(
        value: json['query_days'],
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
      userId: ValueHelper.cast(
        value: json['user_id'],
        type: CastType.int,
      ),
      username: ValueHelper.cast(
        value: json['username'],
        type: CastType.string,
      ),
      userThumb: ValueHelper.cast(
        value: json['user_thumb'],
        type: CastType.string,
      ),
    );
  }
}
