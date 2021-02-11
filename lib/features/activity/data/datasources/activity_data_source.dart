import 'dart:async';

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../domain/entities/activity.dart';
import '../models/activity_model.dart';

abstract class ActivityDataSource {
  Future<List<ActivityItem>> getActivity({
    @required String tautulliId,
  });
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final Settings settings;
  final tautulliApi.GetActivity apiGetActivity;
  final Logging logging;

  ActivityDataSourceImpl({
    @required this.settings,
    @required this.apiGetActivity,
    @required this.logging,
  });

  @override
  Future<List<ActivityItem>> getActivity({
    @required String tautulliId,
  }) async {
    final activityJson = await apiGetActivity(tautulliId);
    final List<ActivityItem> activityList = [];
    activityJson['response']['data']['sessions'].forEach(
      (session) {
        activityList.add(
          ActivityItemModel.fromJson(session),
        );
      },
    );

    return activityList;
  }
}
