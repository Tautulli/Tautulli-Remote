// ignore_for_file: use_null_aware_elements

import 'package:dartz/dartz.dart';

import '../../../../core/api/tautulli_connection_adapter.dart';
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
  final TautulliConnectionAdapter adapter;

  ActivityDataSourceImpl({required this.adapter});

  @override
  Future<Tuple2<List<ActivityModel>, bool>> getActivity({
    required String tautulliId,
    int? sessionKey,
    String? sessionId,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('get_activity', params: {
        if (sessionKey != null) 'session_key': sessionKey,
        if (sessionId != null) 'session_id': sessionId,
      }),
    );

    final List<ActivityModel> activityList =
        (result.data['data']['sessions'] as List?)
                ?.map<ActivityModel>((item) => ActivityModel.fromJson(item))
                .toList() ??
            [];

    return Tuple2(activityList, result.primaryActive);
  }

  @override
  Future<Tuple2<void, bool>> terminateStream({
    required String tautulliId,
    required String? sessionId,
    required int? sessionKey,
    String? message,
  }) async {
    final result = await adapter.call(
      tautulliId: tautulliId,
      action: (client) => client.execute('terminate_session', params: {
        if (sessionId != null) 'session_id': sessionId,
        if (sessionKey != null) 'session_key': sessionKey,
        if (message != null) 'message': message,
      }),
    );

    return Tuple2(null, result.primaryActive);
  }
}
