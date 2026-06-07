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
import 'core/widgets/ios/settings_not_loaded_ios.dart';
import 'core/widgets/ios/tab_scaffold_cupertino.dart';
import 'core/widgets/settings_not_loaded.dart';
import 'dependency_injection.dart' as di;
import 'features/activity/presentation/pages/activity_page.dart';
import 'features/activity/presentation/pages/ios/activity_ios_page.dart';
import 'features/announcements/presentation/pages/announcements_page.dart';
import 'features/announcements/presentation/pages/ios/announcements_ios_page.dart';
import 'features/changelog/presentation/pages/changelog_page.dart';
import 'features/changelog/presentation/pages/ios/changelog_ios_page.dart';
import 'features/donate/presentation/pages/donate_page.dart';
import 'features/donate/presentation/pages/ios/donate_ios_page.dart';
import 'features/graphs/presentation/pages/graphs_page.dart';
import 'features/graphs/presentation/pages/ios/graphs_ios_page.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/history/presentation/pages/ios/history_ios_page.dart';
import 'features/libraries/presentation/pages/cupertino/cupertino_style_libraries_page.dart';
import 'features/libraries/presentation/pages/libraries_page.dart';
import 'features/onesignal/presentation/pages/cupertino/cupertino_style_onesignal_data_privacy_page.dart';
import 'features/onesignal/presentation/pages/onesignal_data_privacy.dart';
import 'features/recently_added/presentation/pages/cupertino/cupertino_style_recently_added_page.dart';
import 'features/recently_added/presentation/pages/recently_added_page.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/cupertino/cupertino_style_settings_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/statistics/presentation/pages/cupertino/cupertino_style_statistics_page.dart';
import 'features/statistics/presentation/pages/statistics_page.dart';
import 'features/translation/presentation/pages/help_translate_page.dart';
import 'features/translation/presentation/pages/cupertino/cupertino_style_help_translate_page.dart';
import 'features/users/presentation/pages/cupertino/cupertino_style_users_page.dart';
import 'features/users/presentation/pages/users_page.dart';
import 'features/wizard/presentation/pages/cupertino/cupertino_style_wizard_page.dart';
import 'features/wizard/presentation/pages/wizard_page.dart';

Map<String, Widget Function(BuildContext)> materialRoutes = {
  ActivityPage.routeName: (_) => const ActivityPage(),
  AnnouncementsPage.routeName: (_) => const AnnouncementsPage(),
  ChangelogPage.routeName: (_) => const ChangelogPage(),
  DonatePage.routeName: (_) => const DonatePage(),
  GraphsPage.routeName: (_) => const GraphsPage(),
  HistoryPage.routeName: (_) => const HistoryPage(),
  HelpTranslatePage.routeName: (_) => const HelpTranslatePage(),
  LibrariesPage.routeName: (_) => const LibrariesPage(),
  OneSignalDataPrivacyPage.routeName: (_) => const OneSignalDataPrivacyPage(),
  RecentlyAddedPage.routeName: (_) => const RecentlyAddedPage(),
  SettingsPage.routeName: (_) => const SettingsPage(),
  StatisticsPage.routeName: (_) => const StatisticsPage(),
  UsersPage.routeName: (_) => const UsersPage(),
  WizardPage.routeName: (_) => const WizardPage(),
};

Map<String, Widget Function(BuildContext)> cupertinoRoutes = {
  ActivityIosPage.routeName: (_) => const ActivityIosPage(),
  AnnouncementsIosPage.routeName: (_) => const AnnouncementsIosPage(),
  ChangelogIosPage.routeName: (_) => const ChangelogIosPage(),
  DonateIosPage.routeName: (_) => const DonateIosPage(),
  GraphsIosPage.routeName: (_) => const GraphsIosPage(),
  CupertinoStyleHelpTranslatePage.routeName: (_) => const CupertinoStyleHelpTranslatePage(),
  HistoryIosPage.routeName: (_) => const HistoryIosPage(),
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
        fontName: useAtkinsonHyperLegible ? 'Atkinson Hyperlegible' : null,
      ),
      builder: (context, child) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsSuccess) {
              return child!;
            }

            return const Scaffold(
              body: SettingsNotLoaded(),
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
        fontName: useAtkinsonHyperLegible ? 'Atkinson Hyperlegible' : null,
      ),
      builder: (context, child) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            // CupertinoTheme does not support a fontName like MaterialTheme. As a result we need to edit the CupertinoTheme and use that to change the Cupertino widgets and the DefaultTextStyle below.
            CupertinoThemeData theme = CupertinoTheme.of(context);
            final fontFamily = GoogleFonts.getFont(
              useAtkinsonHyperLegible ? 'Atkinson Hyperlegible' : 'Open Sans',
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
                  body: SettingsNotLoadedIos(),
                ),
              ),
            );
          },
        );
      },
      routes: cupertinoRoutes,
      home: const TabScaffoldCupertino(),
    );
  }
}
