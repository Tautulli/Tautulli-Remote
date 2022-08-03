import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/database/data/models/server_model.dart';
import 'core/helpers/color_palette_helper.dart';
import 'core/helpers/theme_helper.dart';
import 'core/widgets/settings_not_loaded.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/announcements/presentation/pages/announcements_page.dart';
import 'features/changelog/presentation/pages/changelog_page.dart';
import 'features/donate/presentation/pages/donate_page.dart';
import 'features/graphs/presentation/pages/graphs_page.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/libraries/presentation/pages/libraries_page.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/onesignal/presentation/pages/onesignal_data_privacy.dart';
import 'features/recently_added/presentation/pages/recently_added_page.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/statistics/presentation/pages/statistics_page.dart';
import 'features/translation/presentation/pages/help_translate_page.dart';
import 'features/users/presentation/pages/users_page.dart';
import 'features/wizard/presentation/pages/wizard_page.dart';

class TautulliRemote extends StatefulWidget {
  final String? initialRoute;

  const TautulliRemote({
    super.key,
    this.initialRoute,
  });

  @override
  TautulliRemoteState createState() => TautulliRemoteState();
}

class TautulliRemoteState extends State<TautulliRemote> {
  @override
  void initState() {
    super.initState();
    initalizeOneSignal();
    initalizeFLogConfiguration();

    context.read<OneSignalPrivacyBloc>().add(OneSignalPrivacyCheck());
    // Delay OneSignalSubCheck on app start to avoid calling OSDeviceState
    // before OneSignal is fully initalized
    Future.delayed(const Duration(seconds: 2), () {
      context.read<OneSignalSubBloc>().add(OneSignalSubCheck());
    });
    context.read<SettingsBloc>().add(const SettingsLoad());
    context.read<AnnouncementsBloc>().add(AnnouncementsFetch());
  }

  Future<void> initalizeOneSignal() async {
    if (!mounted) return;

    // await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setLocationShared(false);

    await OneSignal.shared.setRequiresUserPrivacyConsent(true);

    await OneSignal.shared.setAppId("3b4b666a-d557-4b92-acdf-e2c8c4b95357");

    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      // Will be called whenever a notification is received
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      // Will be called whenever the subscription changes

      // Only trigger new checks when userId or pushToken move from null to a value
      if (changes.to.userId != null || changes.to.pushToken != null) {
        context.read<OneSignalSubBloc>().add(OneSignalSubCheck());
        context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());

        if (changes.to.userId != null) {
          final serversWithoutOneSignal = await di.sl<Settings>().getAllServersWithoutOnesignalRegistered();

          if (serversWithoutOneSignal != null && serversWithoutOneSignal.isNotEmpty) {
            di.sl<Logging>().info(
                  'OneSignal :: OneSignal registration changed, updating server registration',
                );

            for (ServerModel server in serversWithoutOneSignal) {
              String connectionProtocol =
                  server.primaryActive! ? server.primaryConnectionProtocol : server.secondaryConnectionProtocol!;
              String connectionDomain =
                  server.primaryActive! ? server.primaryConnectionDomain : server.secondaryConnectionDomain!;
              String? connectionPath =
                  server.primaryActive! ? server.primaryConnectionPath : server.secondaryConnectionPath;

              final failureOrRegisterDevice = await di.sl<Settings>().registerDevice(
                    connectionProtocol: connectionProtocol,
                    connectionDomain: connectionDomain,
                    connectionPath: connectionPath ?? '',
                    deviceToken: server.deviceToken,
                    customHeaders: server.customHeaders,
                  );

              failureOrRegisterDevice.fold(
                (failure) {
                  di.sl<Logging>().error(
                        'OneSignal :: Failed to update registration for ${server.plexName} with OneSignal ID',
                      );
                },
                (results) {
                  di.sl<Settings>().updateServer(
                        server.copyWith(oneSignalRegistered: true),
                      );

                  di.sl<Logging>().info(
                        'OneSignal :: Updated registration for ${server.plexName} with OneSignal ID',
                      );
                },
              );
            }
          }
        }
      }
    });
  }

  void initalizeFLogConfiguration() {
    FLog.applyConfigurations(
      LogsConfig()..activeLogLevel = LogLevel.ALL,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: TautulliColorPalette.midnight,
      ),
    );

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Tautulli Remote',
      theme: ThemeHelper.tautulli(),
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
      routes: {
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
      },
      initialRoute: widget.initialRoute,
      home: const HistoryPage(),
    );
  }
}
