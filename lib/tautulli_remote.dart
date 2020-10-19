import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/helpers/color_palette_helper.dart';
import 'features/activity/presentation/pages/activity_page.dart';
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
  @override
  _TautulliRemoteState createState() => _TautulliRemoteState();
}

class _TautulliRemoteState extends State<TautulliRemote> {
  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    initPlatformState();
    context.bloc<SettingsBloc>().add(SettingsLoad());
    context.bloc<OneSignalHealthBloc>().add(OneSignalHealthCheck());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    //TODO: remove onesignal logging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setLocationShared(false);

    await OneSignal.shared.setRequiresUserPrivacyConsent(true);

    await OneSignal.shared.init("3b4b666a-d557-4b92-acdf-e2c8c4b95357",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        });
    OneSignal.shared
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
      //TODO
      //? call an update to the device registration when userid goes from null to a value
      // Only trigger new checks when userId moves from null to a value
      if (changes.to.userId != null) {
        context
            .bloc<OneSignalSubscriptionBloc>()
            .add(OneSignalSubscriptionCheck());
        context.bloc<OneSignalHealthBloc>().add(OneSignalHealthCheck());
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
        primarySwatch: PlexColorPalette.createSwatch(),
        accentColor: PlexColorPalette.gamboge,
        backgroundColor: TautulliColorPalette.midnight,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.dark().textTheme.copyWith(),
        dialogBackgroundColor: PlexColorPalette.river_bed,
        textSelectionColor: PlexColorPalette.gamboge,
        textSelectionHandleColor: PlexColorPalette.gamboge,
        cursorColor: PlexColorPalette.gamboge,
        canvasColor: PlexColorPalette.shark,
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
        popupMenuTheme: ThemeData.dark().popupMenuTheme.copyWith(
              color: PlexColorPalette.river_bed,
            ),
        dividerColor: TautulliColorPalette.not_white,
        cardColor: PlexColorPalette.shark,
      ),
      routes: {
        ActivityPage.routeName: (ctx) => ActivityPage(),
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
      },
      // home: QuickActionsSetup(),
      home: ActivityPage(),
    );
  }
}

// class QuickActionsSetup extends StatefulWidget {
//   const QuickActionsSetup({Key key}) : super(key: key);

//   @override
//   _QuickActionsSetupState createState() => _QuickActionsSetupState();
// }

// class _QuickActionsSetupState extends State<QuickActionsSetup> {
//   @override
//   void initState() {
//     super.initState();
//     _initQuickActions();
//   }

//   void _initQuickActions() {
//     final QuickActions quickActions = QuickActions();
//     quickActions.initialize((type) {
//       // if (type == 'action_activity') {
//       //   Navigator.of(context).pushReplacementNamed('/activity');
//       // }
//       // if (type == 'action_recent') {
//       //   Navigator.of(context).pushReplacementNamed('/recent');
//       // }
//     });
//     quickActions.setShortcutItems(<ShortcutItem>[
//       // const ShortcutItem(
//       //     type: 'action_activity', localizedTitle: 'Activity', icon: 'tv'),
//       // const ShortcutItem(
//       //     type: 'action_recent', localizedTitle: 'Recent', icon: 'recent'),
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ActivityPage();
//   }
// }
