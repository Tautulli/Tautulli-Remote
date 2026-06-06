import 'package:flutter/cupertino.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> moreTabNavigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<String?> moreNavigationPage = ValueNotifier(null);
final ValueNotifier<String?> cupertinoInitialRoute = ValueNotifier(null);
final CupertinoTabController cupertinoTabController = CupertinoTabController();
