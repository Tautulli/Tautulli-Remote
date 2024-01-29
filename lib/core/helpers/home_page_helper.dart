import 'package:flutter/material.dart';

import '../../dependency_injection.dart' as di;
import '../../features/activity/presentation/pages/activity_page.dart';
import '../../features/graphs/presentation/pages/graphs_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/libraries/presentation/pages/libraries_page.dart';
import '../../features/recently_added/presentation/pages/recently_added_page.dart';
import '../../features/settings/domain/usecases/settings.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/users/presentation/pages/users_page.dart';

class HomePageHelper {
  static Widget get() {
    final homePage = di.sl<Settings>().getHomePage();

    switch (homePage) {
      case ('history'):
        return const HistoryPage();
      case ('recent'):
        return const RecentlyAddedPage();
      case ('libraries'):
        return const LibrariesPage();
      case ('users'):
        return const UsersPage();
      case ('statistics'):
        return const StatisticsPage();
      case ('graphs'):
        return const GraphsPage();
      default:
        return const ActivityPage();
    }
  }
}
