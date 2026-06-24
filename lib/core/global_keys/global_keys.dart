import 'package:flutter/cupertino.dart';

import '../types/app_style.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> moreTabNavigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<String?> moreNavigationPage = ValueNotifier(null);
final ValueNotifier<String?> appInitialRoute = ValueNotifier(null);
final CupertinoTabController cupertinoTabController = CupertinoTabController();
final ValueNotifier<bool> historyRefreshNotifier = ValueNotifier(false);
final ValueNotifier<bool> recentlyAddedRefreshNotifier = ValueNotifier(false);

// Tracks which framework is actually rendered. Written by AppFramework at build
// time so the notification click listener doesn't need to re-read SharedPreferences.
AppStyle currentAppStyle = AppStyle.material;
