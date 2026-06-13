import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system_theme/system_theme.dart';

import 'core/global_keys/global_keys.dart';
import 'core/helpers/home_page_helper.dart';
import 'core/helpers/theme_helper.dart';
import 'core/types/app_style.dart';
import 'core/types/theme_enhancement_type.dart';
import 'core/types/theme_type.dart';
import 'core/widgets/cupertino/cupertino_style_settings_not_loaded.dart';
import 'core/widgets/cupertino/cupertino_style_tab_scaffold.dart';
import 'core/widgets/material/material_style_settings_not_loaded.dart';
import 'dependency_injection.dart' as di;
import 'features/activity/presentation/pages/cupertino/cupertino_style_activity_page.dart';
import 'features/activity/presentation/pages/material/material_style_activity_page.dart';
import 'features/announcements/presentation/pages/cupertino/cupertino_style_announcements_page.dart';
import 'features/announcements/presentation/pages/material/material_style_announcements_page.dart';
import 'features/changelog/presentation/pages/cupertino/cupertino_style_changelog_page.dart';
import 'features/changelog/presentation/pages/material/material_style_changelog_page.dart';
import 'features/donate/presentation/pages/cupertino/cupertino_style_donate_page.dart';
import 'features/donate/presentation/pages/material/material_style_donate_page.dart';
import 'features/graphs/presentation/pages/cupertino/cupertino_style_graphs_page.dart';
import 'features/graphs/presentation/pages/material/material_style_graphs_page.dart';
import 'features/history/presentation/pages/cupertino/cupertino_style_history_page.dart';
import 'features/history/presentation/pages/material/material_style_history_page.dart';
import 'features/libraries/presentation/pages/cupertino/cupertino_style_libraries_page.dart';
import 'features/libraries/presentation/pages/material/material_style_libraries_page.dart';
import 'features/onesignal/presentation/pages/cupertino/cupertino_style_onesignal_data_privacy_page.dart';
import 'features/onesignal/presentation/pages/material/material_style_onesignal_data_privacy_page.dart';
import 'features/recently_added/presentation/pages/cupertino/cupertino_style_recently_added_page.dart';
import 'features/recently_added/presentation/pages/material/material_style_recently_added_page.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/cupertino/cupertino_style_settings_page.dart';
import 'features/settings/presentation/pages/material/material_style_settings_page.dart';
import 'features/statistics/presentation/pages/cupertino/cupertino_style_statistics_page.dart';
import 'features/statistics/presentation/pages/material/material_style_statistics_page.dart';
import 'features/translation/presentation/pages/cupertino/cupertino_style_help_translate_page.dart';
import 'features/translation/presentation/pages/material/material_style_help_translate_page.dart';
import 'features/users/presentation/pages/cupertino/cupertino_style_users_page.dart';
import 'features/users/presentation/pages/material/material_style_users_page.dart';
import 'features/wizard/presentation/pages/cupertino/cupertino_style_wizard_page.dart';
import 'features/wizard/presentation/pages/material/material_style_wizard_page.dart';

Map<String, Widget Function(BuildContext)> materialRoutes = {
  MaterialStyleActivityPage.routeName: (_) => const MaterialStyleActivityPage(),
  MaterialStyleAnnouncementsPage.routeName: (_) => const MaterialStyleAnnouncementsPage(),
  MaterialStyleChangelogPage.routeName: (_) => const MaterialStyleChangelogPage(),
  MaterialStyleDonatePage.routeName: (_) => const MaterialStyleDonatePage(),
  MaterialStyleGraphsPage.routeName: (_) => const MaterialStyleGraphsPage(),
  MaterialStyleHistoryPage.routeName: (_) => const MaterialStyleHistoryPage(),
  MaterialStyleHelpTranslatePage.routeName: (_) => const MaterialStyleHelpTranslatePage(),
  MaterialStyleLibrariesPage.routeName: (_) => const MaterialStyleLibrariesPage(),
  MaterialStyleOneSignalDataPrivacyPage.routeName: (_) => const MaterialStyleOneSignalDataPrivacyPage(),
  MaterialStyleRecentlyAddedPage.routeName: (_) => const MaterialStyleRecentlyAddedPage(),
  MaterialStyleSettingsPage.routeName: (_) => const MaterialStyleSettingsPage(),
  MaterialStyleStatisticsPage.routeName: (_) => const MaterialStyleStatisticsPage(),
  MaterialStyleUsersPage.routeName: (_) => const MaterialStyleUsersPage(),
  MaterialStyleWizardPage.routeName: (_) => const MaterialStyleWizardPage(),
};

Map<String, Widget Function(BuildContext)> cupertinoRoutes = {
  CupertinoStyleActivityPage.routeName: (_) => const CupertinoStyleActivityPage(),
  CupertinoStyleAnnouncementsPage.routeName: (_) => const CupertinoStyleAnnouncementsPage(),
  CupertinoStyleChangelogPage.routeName: (_) => const CupertinoStyleChangelogPage(),
  CupertinoStyleDonatePage.routeName: (_) => const CupertinoStyleDonatePage(),
  CupertinoStyleGraphsPage.routeName: (_) => const CupertinoStyleGraphsPage(),
  CupertinoStyleHelpTranslatePage.routeName: (_) => const CupertinoStyleHelpTranslatePage(),
  CupertinoStyleHistoryPage.routeName: (_) => const CupertinoStyleHistoryPage(),
  CupertinoStyleLibrariesPage.routeName: (_) => const CupertinoStyleLibrariesPage(),
  CupertinoStyleOnesignalDataPrivacyPage.routeName: (_) => const CupertinoStyleOnesignalDataPrivacyPage(),
  CupertinoStyleRecentlyAddedPage.routeName: (_) => const CupertinoStyleRecentlyAddedPage(),
  CupertinoStyleSettingsPage.routeName: (_) => const CupertinoStyleSettingsPage(),
  CupertinoStyleStatisticsPage.routeName: (_) => const CupertinoStyleStatisticsPage(),
  CupertinoStyleUsersPage.routeName: (_) => const CupertinoStyleUsersPage(),
  CupertinoStyleWizardPage.routeName: (_) => const CupertinoStyleWizardPage(),
};

class AppFramework extends StatelessWidget {
  final String? initialRoute;

  const AppFramework({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          final bool fontChange =
              previous.appSettings.useAtkinsonHyperlegible != current.appSettings.useAtkinsonHyperlegible;
          final bool currentThemeIsDynamic = current.appSettings.theme == ThemeType.dynamic;
          final bool themeChange = previous.appSettings.theme != current.appSettings.theme;
          final bool themeSystemColorChange =
              previous.appSettings.themeUseSystemColor != current.appSettings.themeUseSystemColor;
          final bool themeCustomColorChange =
              previous.appSettings.themeCustomColor != current.appSettings.themeCustomColor;
          final bool themeEnhancementChange =
              previous.appSettings.themeEnhancement != current.appSettings.themeEnhancement;

          if (fontChange ||
              themeChange ||
              themeEnhancementChange ||
              (currentThemeIsDynamic && (themeSystemColorChange || themeCustomColorChange))) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        final bool useAtkinsonHyperLegible = di.sl<Settings>().getUseAtkinsonHyperlegible();
        final ThemeType theme = di.sl<Settings>().getTheme();
        final bool themeUseSystemColor = di.sl<Settings>().getThemeUseSystemColor();
        final Color themeCustomColor = di.sl<Settings>().getThemeCustomColor();
        final Color systemColor = SystemTheme.accentColor.accent;
        final ThemeEnhancementType themeEnhancement = di.sl<Settings>().getThemeEnhancement();

        if (di.sl<Settings>().getAppStyle() == AppStyle.cupertino) {
          currentAppStyle = AppStyle.cupertino;
          return _CupertinoFramework(
            // initialRoute: initialRoute,
            useAtkinsonHyperLegible: useAtkinsonHyperLegible,
            theme: theme,
            themeUseSystemColor: themeUseSystemColor,
            themeCustomColor: themeCustomColor,
            systemColor: systemColor,
            themeEnhancement: themeEnhancement,
          );
        }

        // Material handles the initial route itself via MaterialApp.initialRoute.
        // Clear the Cupertino notifier so a later switch to Cupertino doesn't
        // re-trigger the same route in CupertinoStyleTabScaffold.initState.
        if (initialRoute != null) {
          cupertinoInitialRoute.value = null;
        }

        currentAppStyle = AppStyle.material;
        return _MaterialFramework(
          initialRoute: initialRoute,
          useAtkinsonHyperLegible: useAtkinsonHyperLegible,
          theme: theme,
          themeUseSystemColor: themeUseSystemColor,
          themeCustomColor: themeCustomColor,
          systemColor: systemColor,
          themeEnhancement: themeEnhancement,
        );
      },
    );
  }
}

class _MaterialFramework extends StatelessWidget {
  final String? initialRoute;
  final bool useAtkinsonHyperLegible;
  final ThemeType theme;
  final bool themeUseSystemColor;
  final Color themeCustomColor;
  final Color systemColor;
  final ThemeEnhancementType themeEnhancement;

  const _MaterialFramework({
    required this.initialRoute,
    required this.useAtkinsonHyperLegible,
    required this.theme,
    required this.themeUseSystemColor,
    required this.themeCustomColor,
    required this.systemColor,
    required this.themeEnhancement,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Tautulli Remote',
      theme: ThemeHelper.materialThemeSelector(
        theme: theme,
        color: (themeUseSystemColor && defaultTargetPlatform.supportsAccentColor) ? systemColor : themeCustomColor,
        enhancement: themeEnhancement,
        fontName: useAtkinsonHyperLegible ? 'Atkinson Hyperlegible Next' : null,
      ),
      builder: (context, child) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsSuccess) {
              return child!;
            }

            return const Scaffold(
              body: MaterialStyleSettingsNotLoaded(),
            );
          },
        );
      },
      routes: materialRoutes,
      initialRoute: initialRoute,
      home: HomePageHelper.get(),
    );
  }
}

class _CupertinoFramework extends StatelessWidget {
  final bool useAtkinsonHyperLegible;
  final ThemeType theme;
  final bool themeUseSystemColor;
  final Color themeCustomColor;
  final Color systemColor;
  final ThemeEnhancementType themeEnhancement;

  const _CupertinoFramework({
    required this.useAtkinsonHyperLegible,
    required this.theme,
    required this.themeUseSystemColor,
    required this.themeCustomColor,
    required this.systemColor,
    required this.themeEnhancement,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Tautulli Remote',
      theme: ThemeHelper.cupertinoThemeSelector(
        theme: theme,
        color: (themeUseSystemColor && defaultTargetPlatform.supportsAccentColor) ? systemColor : themeCustomColor,
        enhancement: themeEnhancement,
        fontName: useAtkinsonHyperLegible ? 'Atkinson Hyperlegible Next' : null,
      ),
      builder: (context, child) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            // CupertinoTheme does not support a fontName like MaterialTheme. As a result we need to edit the CupertinoTheme and use that to change the Cupertino widgets and the DefaultTextStyle below.
            CupertinoThemeData theme = CupertinoTheme.of(context);
            final fontFamily = GoogleFonts.getFont(
              useAtkinsonHyperLegible ? 'Atkinson Hyperlegible Next' : 'Open Sans',
            ).fontFamily;
            final cupertinoTheme = theme.copyWith(
              textTheme: theme.textTheme.copyWith(
                textStyle: theme.textTheme.textStyle.copyWith(fontFamily: fontFamily),
                navLargeTitleTextStyle: theme.textTheme.navLargeTitleTextStyle.copyWith(fontFamily: fontFamily),
                actionTextStyle: theme.textTheme.actionTextStyle.copyWith(fontFamily: fontFamily),
                dateTimePickerTextStyle: theme.textTheme.dateTimePickerTextStyle.copyWith(fontFamily: fontFamily),
                navActionTextStyle: theme.textTheme.navActionTextStyle.copyWith(fontFamily: fontFamily),
                navTitleTextStyle: theme.textTheme.navTitleTextStyle.copyWith(fontFamily: fontFamily),
                pickerTextStyle: theme.textTheme.pickerTextStyle.copyWith(fontFamily: fontFamily),
                tabLabelTextStyle: theme.textTheme.tabLabelTextStyle.copyWith(fontFamily: fontFamily),
              ),
            );

            if (state is SettingsSuccess) {
              return CupertinoTheme(
                data: cupertinoTheme,
                child: DefaultTextStyle(
                  style: cupertinoTheme.textTheme.textStyle,
                  child: child!,
                ),
              );
            }

            return CupertinoTheme(
              data: cupertinoTheme,
              child: DefaultTextStyle(
                style: cupertinoTheme.textTheme.textStyle,
                child: const Scaffold(
                  body: CupertinoStyleSettingsNotLoaded(),
                ),
              ),
            );
          },
        );
      },
      routes: cupertinoRoutes,
      home: const CupertinoStyleTabScaffold(),
    );
  }
}
