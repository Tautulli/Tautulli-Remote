import 'dart:async';

import 'package:meta/meta.dart';

import '../../../../core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
import '../../../settings/domain/usecases/settings.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/activity.dart';
import '../models/activity_model.dart';

abstract class ActivityDataSource {
  Future<List<ActivityItem>> getActivity({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  });
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final Settings settings;
  final tautulliApi.GetActivity apiGetActivity;

  ActivityDataSourceImpl({
    @required this.settings,
    @required this.apiGetActivity,
  });

  @override
  Future<List<ActivityItem>> getActivity({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    final activityJson = await apiGetActivity(
      tautulliId: tautulliId,
      settingsBloc: settingsBloc,
    );
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
