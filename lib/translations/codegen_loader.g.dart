// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "activity_empty": "Nothing is currently being played.",
  "activity_page_title": "Activity",
  "history_page_title": "History",
  "recently_added_page_title": "Recently Added",
  "libraries_page_title": "Libraries",
  "users_page_title": "Users",
  "statistics_page_title": "Statistics",
  "graphs_page_title": "Graphs",
  "synced_items_page_title": "Synced Items",
  "announcements_page_title": "Announcements",
  "donate_page_title": "Donate",
  "settings_page_title": "Settings"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en};
}
