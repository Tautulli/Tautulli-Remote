import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli/tautulli_api.dart';
import '../models/activity_model.dart';

abstract class ActivityDataSource {
  Future<Tuple2<List<ActivityModel>, bool>> getActivity({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  });

  Future<Tuple2<void, bool>> terminateStream({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  });
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final GetActivity getActivityApi;
  final TerminateSession terminateStreamApi;

  ActivityDataSourceImpl({
    required this.getActivityApi,
    required this.terminateStreamApi,
  });

  @override
  Future<Tuple2<List<ActivityModel>, bool>> getActivity({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  }) async {
    final result = await getActivityApi(
      tautulliId: tautulliId,
      sessionKey: sessionKey,
      sessionId: sessionId,
    );

    final List<ActivityModel> activityList = result.value1['response']['data']['sessions']
        .map<ActivityModel>((activityItem) => ActivityModel.fromJson(activityItem))
        .toList();

    return Tuple2(activityList, result.value2);
  }

  @override
  Future<Tuple2<void, bool>> terminateStream({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  }) async {
    final result = await terminateStreamApi(
      tautulliId: tautulliId,
      sessionId: sessionId,
      sessionKey: sessionKey,
      message: message,
    );

    return Tuple2(null, result.value2);
  }
}
