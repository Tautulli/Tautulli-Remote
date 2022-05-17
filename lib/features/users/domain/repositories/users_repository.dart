import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_player_stat_model.dart';
import '../../data/models/user_watch_time_stat_model.dart';

abstract class UsersRepository {
  Future<Either<Failure, Tuple2<List<UserPlayerStatModel>, bool>>>
      getPlayerStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
  });

  Future<Either<Failure, Tuple2<List<UserWatchTimeStatModel>, bool>>>
      getWatchTimeStats({
    required String tautulliId,
    required int userId,
    bool? grouping,
    String? queryDays,
  });

  Future<Either<Failure, Tuple2<List<UserModel>, bool>>> getUsers({
    required String tautulliId,
    bool? grouping,
    String? orderColumn,
    String? orderDir,
    int? start,
    int? length,
    String? search,
  });
}
