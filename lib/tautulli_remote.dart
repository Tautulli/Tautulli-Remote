import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/helpers/color_palette_helper.dart';
import 'features/activity/presentation/pages/activity_page.dart';
import 'features/announcements/presentation/pages/announcements_page.dart';
import 'features/changelog/presentation/pages/changelog_page.dart';
import 'features/donate/presentation/pages/donate_page.dart';
import 'features/help/presentation/pages/help_page.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/libraries/presentation/pages/libraries_page.dart';
import 'features/logging/presentation/pages/logs_page.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/privacy/presentation/pages/privacy_page.dart';
import 'features/recent/presentation/pages/recently_added_page.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/statistics/presentation/pages/statistics_page.dart';
import 'features/synced_items/presentation/pages/synced_items_page.dart';
import 'features/users/presentation/pages/users_page.dart';

class TautulliRemote extends StatefulWidget {
  final bool showChangelog;

  const TautulliRemote({
    @required this.showChangelog,
    Key key,
  }) : super(key: key);

  @override
  _TautulliRemoteState createState() => _TautulliRemoteState();
}

class _TautulliRemoteState extends State<TautulliRemote> {
  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    initPlatformState();
    context.read<SettingsBloc>().add(
          SettingsLoad(
            settingsBloc: context.read<SettingsBloc>(),
          ),
        );
    context.read<SettingsBloc>().add(SettingsUpdateLastAppVersion());
    context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    //TODO: remove onesignal logging
    await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setLocationShared(false);

    await OneSignal.shared.setRequiresUserPrivacyConsent(true);

    await OneSignal.shared.init("3b4b666a-d557-4b92-acdf-e2c8c4b95357",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        });
    await OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) async {
      // will be called whenever a notification is received
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // push new events for SubscriptionBloc and HealthBloc when there is a subscription change

      // Only trigger new checks when userId or pushToken move from null to a value
      if (changes.to.userId != null || changes.to.pushToken != null) {
        context
            .read<OneSignalSubscriptionBloc>()
            .add(OneSignalSubscriptionCheck());
        context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());
      }
    });
  }

  // Initialize FlutterFire
  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Error initalizing Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: PlexColorPalette.shark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Function used with textButtonTheme ButtonStyle to force foregroundColor
    Color getTextButtonColor(Set<MaterialState> states) {
      return TautulliColorPalette.not_white;
    }

    return MaterialApp(
      title: 'Tautulli Remote',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: PlexColorPalette.createSwatch(),
        accentColor: PlexColorPalette.gamboge,
        backgroundColor: TautulliColorPalette.midnight,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: TautulliColorPalette.not_white,
            ),
        dialogBackgroundColor: PlexColorPalette.river_bed,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: PlexColorPalette.gamboge,
          selectionHandleColor: PlexColorPalette.gamboge,
          cursorColor: PlexColorPalette.gamboge,
        ),
        canvasColor: PlexColorPalette.shark,
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(
            color: TautulliColorPalette.not_white,
          ),
        ),
        inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TautulliColorPalette.not_white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PlexColorPalette.gamboge),
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              labelStyle: TextStyle(
                color: TautulliColorPalette.not_white,
              ),
              helperStyle: TextStyle(
                color: TautulliColorPalette.not_white,
              ),
            ),
        unselectedWidgetColor: TautulliColorPalette.not_white,
        buttonTheme: ThemeData.dark().buttonTheme.copyWith(),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.resolveWith(getTextButtonColor),
          ),
        ),
        toggleableActiveColor: PlexColorPalette.gamboge,
        popupMenuTheme: ThemeData.dark().popupMenuTheme.copyWith(
              color: PlexColorPalette.river_bed,
            ),
        dividerColor: TautulliColorPalette.not_white,
        cardColor: PlexColorPalette.shark,
      ),
      routes: {
        ActivityPage.routeName: (ctx) => ActivityPage(),
        AnnouncementsPage.routeName: (ctx) => AnnouncementsPage(),
        HistoryPage.routeName: (ctx) => HistoryPage(),
        RecentlyAddedPage.routeName: (ctx) => RecentlyAddedPage(),
        LibrariesPage.routeName: (ctx) => LibrariesPage(),
        UsersPage.routeName: (ctx) => UsersPage(),
        StatisticsPage.routeName: (ctx) => StatisticsPage(),
        SyncedItemsPage.routeName: (ctx) => SyncedItemsPage(),
        HelpPage.routeName: (ctx) => HelpPage(),
        DonatePage.routeName: (ctx) => DonatePage(),
        SettingsPage.routeName: (ctx) => SettingsPage(),
        PrivacyPage.routeName: (ctx) => PrivacyPage(),
        LogsPage.routeName: (ctx) => LogsPage(),
        ChangelogPage.routeName: (ctx) => ChangelogPage(),
      },
      initialRoute: widget.showChangelog ? '/changelog' : null,
      home: ActivityPage(),
    );
  }
}
