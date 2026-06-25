import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_app_group_directory/flutter_app_group_directory.dart';
import 'package:path_provider/path_provider.dart';

import '../models/notification_log_entry_model.dart';

abstract class NotificationLogsDataSource {
  Future<List<NotificationLogEntryModel>> getLogs();
  Future<void> clearLogs();
}

class NotificationLogsDataSourceImpl implements NotificationLogsDataSource {
  static const String _fileName = 'notification_diagnostic_log.json';
  static const String _appGroup = 'group.com.tautulli.tautulliRemote.onesignal';

  Future<File> _logFile() async {
    final Directory? dir = (defaultTargetPlatform == TargetPlatform.iOS)
        ? await FlutterAppGroupDirectory.getAppGroupDirectory(_appGroup)
        : await getApplicationDocumentsDirectory();

    if (dir == null) throw Exception('Could not resolve log directory');
    return File('${dir.path}/$_fileName');
  }

  @override
  Future<List<NotificationLogEntryModel>> getLogs() async {
    final file = await _logFile();
    if (!file.existsSync()) return [];

    final content = await file.readAsString();
    final List<dynamic> raw = jsonDecode(content) as List<dynamic>;
    return raw
        .map((e) => NotificationLogEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearLogs() async {
    final file = await _logFile();
    if (file.existsSync()) await file.delete();
  }
}
