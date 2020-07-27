import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/helpers/color_palette_helper.dart';
import 'features/activity/presentation/pages/activity_page.dart';
import 'features/logging/presentation/pages/logs_page.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/privacy/presentation/pages/privacy_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

class TautulliRemote extends StatefulWidget {
  @override
  _TautulliRemoteState createState() => _TautulliRemoteState();
}

class _TautulliRemoteState extends State<TautulliRemote> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
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
      BlocProvider.of<OneSignalSubscriptionBloc>(context)
          .add(OneSignalSubscriptionCheck());
      BlocProvider.of<OneSignalHealthBloc>(context).add(OneSignalHealthCheck());
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: PlexColorPalette.river_bed,
        // statusBarColor: PlexColorPalette.shark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Tautulli Remote',
      theme: ThemeData(
        primarySwatch: PlexColorPalette.createSwatch(),
        accentColor: PlexColorPalette.gamboge,
        backgroundColor: PlexColorPalette.river_bed,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.dark().textTheme.copyWith(),
        dialogBackgroundColor: PlexColorPalette.river_bed,
        textSelectionColor: PlexColorPalette.gamboge,
        textSelectionHandleColor: PlexColorPalette.gamboge,
        cursorColor: PlexColorPalette.gamboge,
        canvasColor: PlexColorPalette.shark,
        inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PlexColorPalette.gamboge),
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              labelStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
        buttonTheme: ThemeData.dark().buttonTheme.copyWith(),
        popupMenuTheme: ThemeData.dark().popupMenuTheme.copyWith(
          color: PlexColorPalette.river_bed,
        ),
      ),
      home: ActivityPage(),
      routes: {
        ActivityPage.routeName: (ctx) => ActivityPage(),
        SettingsPage.routeName: (ctx) => SettingsPage(),
        PrivacyPage.routeName: (ctx) => PrivacyPage(),
        LogsPage.routeName: (ctx) => LogsPage(),
      },
    );
  }
}
