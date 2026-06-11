import 'package:flutter/material.dart';

import '../../dependency_injection.dart' as di;
import '../../features/activity/presentation/pages/material/material_style_activity_page.dart';
import '../../features/graphs/presentation/pages/material_style_graphs_page.dart';
import '../../features/history/presentation/pages/material/material_style_history_page.dart';
import '../../features/libraries/presentation/pages/material/material_style_libraries_page.dart';
import '../../features/recently_added/presentation/pages/material/material_style_recently_added_page.dart';
import '../../features/settings/domain/usecases/settings.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/users/presentation/pages/users_page.dart';

class HomePageHelper {
  static Widget get() {
    final homePage = di.sl<Settings>().getHomePage();

    switch (homePage) {
      case ('history'):
        return const MaterialStyleHistoryPage();
      case ('recent'):
        return const MaterialStyleRecentlyAddedPage();
      case ('libraries'):
        return const MaterialStyleLibrariesPage();
      case ('users'):
        return const UsersPage();
      case ('statistics'):
        return const StatisticsPage();
      case ('graphs'):
        return const MaterialStyleGraphsPage();
      default:
        return const MaterialStyleActivityPage();
    }
  }
}
