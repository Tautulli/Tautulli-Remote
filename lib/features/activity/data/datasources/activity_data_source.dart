import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../settings/domain/usecases/get_settings.dart';
import '../../domain/entities/activity.dart';
import '../models/activity_model.dart';

abstract class ActivityDataSource {
  /// Returns a list of [ActivityItem].
  /// 
  /// Thows a [SettingsException] if the [connectionAddress] or 
  /// [deviceToken] are null. Throws a [ServerException] if the 
  /// server responds with a [StatusCode] other than 200.
  Future<List<ActivityItem>> getActivity();
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final http.Client client;
  final GetSettings getSettings;
  final TautulliApiUrls tautulliApiUrls;

  ActivityDataSourceImpl({
    @required this.client,
    @required this.getSettings,
    @required this.tautulliApiUrls,
  });

  @override
  Future<List<ActivityItem>> getActivity() async {
    final settings = await getSettings.load();
    final connectionAddress = settings.connectionAddress;
    final connectionProtocol = settings.connectionProtocol;
    final connectionDomain = settings.connectionDomain;
    final connectionUser = settings.connectionUser;
    final connectionPassword = settings.connectionPassword;
    final deviceToken = settings.deviceToken;

    if ((connectionAddress == null || deviceToken == null)) {
      throw SettingsException();
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (connectionUser != null && connectionPassword != null) {
      headers['authorization'] = 'Basic ' +
          base64Encode(
            utf8.encode('$connectionUser:$connectionPassword'),
          );
    }

    final response = await client.get(
      tautulliApiUrls.getActivityUrl(
        protocol: connectionProtocol,
        domain: connectionDomain,
        deviceToken: deviceToken,
      ),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      final List<ActivityItem> activityList = [];

      responseJson['response']['data']['sessions'].forEach(
        (session) {
          activityList.add(
            ActivityItemModel.fromJson(session),
          );
        },
      );
      return activityList;
    } else {
      throw ServerException();
    }
  }
}
