import 'package:easy_localization/easy_localization.dart';
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
import 'features/graphs/presentation/pages/graphs_page.dart';
import 'features/help/presentation/pages/help_page.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/libraries/presentation/pages/libraries_page.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/logging/presentation/pages/logs_page.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/privacy/presentation/pages/privacy_page.dart';
import 'features/recent/presentation/pages/recently_added_page.dart';
import 'features/settings/domain/usecases/register_device.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/statistics/presentation/pages/statistics_page.dart';
import 'features/synced_items/presentation/pages/synced_items_page.dart';
import 'features/translate/presentation/pages/translate_page.dart';
import 'features/users/presentation/pages/users_page.dart';
import 'features/wizard/presentation/pages/wizard_page.dart';
import 'injection_container.dart' as di;

class TautulliRemote extends StatefulWidget {
  final bool showWizard;
  final bool showChangelog;

  const TautulliRemote({
    @required this.showWizard,
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

    await OneSignal.shared.setAppId("3b4b666a-d557-4b92-acdf-e2c8c4b95357");

    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      // will be called whenever a notification is received
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      // push new events for SubscriptionBloc and HealthBloc when there is a subscription change

      // Only trigger new checks when userId or pushToken move from null to a value
      if (changes.to.userId != null || changes.to.pushToken != null) {
        context
            .read<OneSignalSubscriptionBloc>()
            .add(OneSignalSubscriptionCheck());
        context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());
      }

      if (changes.to.userId != null) {
        final serversRegisteredWithoutOnesignal =
            await di.sl<Settings>().getAllServersWithoutOnesignalRegistered();

        if (serversRegisteredWithoutOnesignal.isNotEmpty) {
          for (var i = 0; i < serversRegisteredWithoutOnesignal.length; i++) {
            final server = serversRegisteredWithoutOnesignal[i];
            final failureOrRegisterDevice = await di.sl<RegisterDevice>()(
              connectionProtocol: server.primaryActive
                  ? server.primaryConnectionProtocol
                  : server.secondaryConnectionProtocol,
              connectionDomain: server.primaryActive
                  ? server.primaryConnectionDomain
                  : server.secondaryConnectionDomain,
              connectionPath: server.primaryActive
                  ? server.primaryConnectionPath
                  : server.secondaryConnectionPath,
              deviceToken: server.deviceToken,
              trustCert: false,
            );
            failureOrRegisterDevice.fold(
              (failure) {
                di.sl<Logging>().error(
                      'OneSignal: Failed to update registration with OneSignal User ID for ${server.plexName}',
                    );
              },
              (registeredData) {
                di.sl<Logging>().info(
                      'OneSignal: Updating registration with OneSignal User ID for ${server.plexName}',
                    );

                di.sl<Settings>().updateServer(
                      server.copyWith(onesignalRegistered: true),
                    );
              },
            );
          }
        }
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
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
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
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: PlexColorPalette.gamboge,
          selectionHandleColor: PlexColorPalette.gamboge,
          cursorColor: PlexColorPalette.gamboge,
        ),
        canvasColor: PlexColorPalette.shark,
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(
            color: TautulliColorPalette.not_white,
          ),
        ),
        inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: TautulliColorPalette.not_white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PlexColorPalette.gamboge),
              ),
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              labelStyle: const TextStyle(
                color: TautulliColorPalette.not_white,
              ),
              helperStyle: const TextStyle(
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
        ActivityPage.routeName: (ctx) => const ActivityPage(),
        AnnouncementsPage.routeName: (ctx) => const AnnouncementsPage(),
        ChangelogPage.routeName: (ctx) => const ChangelogPage(),
        TranslatePage.routeName: (ctx) => const TranslatePage(),
        DonatePage.routeName: (ctx) => const DonatePage(),
        GraphsPage.routeName: (ctx) => const GraphsPage(),
        HelpPage.routeName: (ctx) => const HelpPage(),
        HistoryPage.routeName: (ctx) => const HistoryPage(),
        LibrariesPage.routeName: (ctx) => const LibrariesPage(),
        LogsPage.routeName: (ctx) => const LogsPage(),
        PrivacyPage.routeName: (ctx) => const PrivacyPage(),
        RecentlyAddedPage.routeName: (ctx) => const RecentlyAddedPage(),
        SettingsPage.routeName: (ctx) => const SettingsPage(),
        StatisticsPage.routeName: (ctx) => const StatisticsPage(),
        SyncedItemsPage.routeName: (ctx) => const SyncedItemsPage(),
        UsersPage.routeName: (ctx) => const UsersPage(),
        WizardPage.routeName: (ctx) => const WizardPage(),
      },
      initialRoute: widget.showWizard
          ? '/wizard'
          : widget.showChangelog
              ? '/changelog'
              : null,
      home: const ActivityPage(),
    );
  }
}
