import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/database/data/models/server_model.dart';
import 'core/helpers/color_palette_helper.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/announcements/presentation/pages/announcements_page.dart';
import 'features/changelog/presentation/pages/changelog_page.dart';
import 'features/donate/presentation/pages/donate_page.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/onesignal/presentation/pages/onesignal_data_privacy.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/translation/presentation/pages/help_translate_page.dart';

class TautulliRemote extends StatefulWidget {
  const TautulliRemote({Key? key}) : super(key: key);

  @override
  _TautulliRemoteState createState() => _TautulliRemoteState();
}

class _TautulliRemoteState extends State<TautulliRemote> {
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

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      // Will be called whenever the subscription changes

      // Only trigger new checks when userId or pushToken move from null to a value
      if (changes.to.userId != null || changes.to.pushToken != null) {
        context.read<OneSignalSubBloc>().add(OneSignalSubCheck());
        context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());

        if (changes.to.userId != null) {
          final serversWithoutOneSignal =
              await di.sl<Settings>().getAllServersWithoutOnesignalRegistered();

          if (serversWithoutOneSignal != null &&
              serversWithoutOneSignal.isNotEmpty) {
            di.sl<Logging>().info(
                  'OneSignal :: OneSignal registration changed, updating server registration',
                );

            for (ServerModel server in serversWithoutOneSignal) {
              String connectionProtocol = server.primaryActive!
                  ? server.primaryConnectionProtocol
                  : server.secondaryConnectionProtocol!;
              String connectionDomain = server.primaryActive!
                  ? server.primaryConnectionDomain
                  : server.secondaryConnectionDomain!;
              String? connectionPath = server.primaryActive!
                  ? server.primaryConnectionPath
                  : server.secondaryConnectionPath;

              final failureOrRegisterDevice =
                  await di.sl<Settings>().registerDevice(
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: TautulliColorPalette.midnight,
      ),
    );

    final ThemeData theme = ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        color: TautulliColorPalette.midnight,
        iconTheme: const IconThemeData(
          color: TautulliColorPalette.notWhite,
        ),
        titleTextStyle: GoogleFonts.openSans(
          textStyle: const TextStyle(
            fontSize: 20,
            color: TautulliColorPalette.notWhite,
          ),
        ),
      ),
      bannerTheme: const MaterialBannerThemeData(
        elevation: 1,
      ),
      cardColor: TautulliColorPalette
          .gunmetal, //Flutter's 'About Licenses' page uses the cardColor
      cardTheme: const CardTheme(
        margin: EdgeInsets.all(0),
        elevation: 0,
        color: TautulliColorPalette.gunmetal,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
            return null;
          },
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: TautulliColorPalette.createSwatch(),
        brightness: Brightness.dark,
        errorColor: Colors.red[900],
      ).copyWith(
        secondary: PlexColorPalette.gamboge,
        tertiary: TautulliColorPalette.notWhite,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: TautulliColorPalette.gunmetal,
      ),
      dividerTheme: const DividerThemeData(
        color: PlexColorPalette.gamboge,
        thickness: 1,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: TautulliColorPalette.gunmetal,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: PlexColorPalette.gamboge,
          onPrimary: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: TautulliColorPalette.notWhite,
        extendedTextStyle: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(
        color: TautulliColorPalette.notWhite,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: TautulliColorPalette.smoke,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[900]!,
          ),
        ),
        // floatingLabelStyle: TextStyle(
        //   color: PlexColorPalette.gamboge,
        // ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: PlexColorPalette.gamboge,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[900]!,
          ),
        ),
        iconColor: TautulliColorPalette.smoke,
        isDense: true,
        labelStyle: const TextStyle(
          color: TautulliColorPalette.smoke,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: TautulliColorPalette.notWhite,
        tileColor: TautulliColorPalette.gunmetal,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: PlexColorPalette.gamboge,
          side: const BorderSide(
            color: PlexColorPalette.gamboge,
          ),
        ),
      ),
      primarySwatch: TautulliColorPalette.createSwatch(),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: TautulliColorPalette.notWhite,
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
            return null;
          },
        ),
      ),
      scaffoldBackgroundColor: TautulliColorPalette.midnight,
      snackBarTheme: const SnackBarThemeData(
        actionTextColor: TautulliColorPalette.notWhite,
        behavior: SnackBarBehavior.floating,
        backgroundColor: PlexColorPalette.shark,
        contentTextStyle: TextStyle(
          color: TautulliColorPalette.notWhite,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
            return null;
          },
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge.withAlpha(175);
            }
            return null;
          },
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: TautulliColorPalette.notWhite,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: PlexColorPalette.gamboge,
        selectionHandleColor: PlexColorPalette.gamboge,
        selectionColor: PlexColorPalette.gamboge,
      ),
      textTheme: GoogleFonts.openSansTextTheme(
        ThemeData.dark().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              bodyText2: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              button: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              caption: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline1: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline2: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline3: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline4: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline5: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline6: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              overline: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              subtitle1: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              subtitle2: const TextStyle(
                color: TautulliColorPalette.smoke,
              ),
            ),
      ),
      unselectedWidgetColor: TautulliColorPalette.notWhite,
    );

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Tautulli Remote',
      theme: theme,
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor:
                data.textScaleFactor < 1.15 ? data.textScaleFactor : 1.15,
          ),
          child: child!,
        );
      },
      routes: {
        AnnouncementsPage.routeName: (_) => const AnnouncementsPage(),
        ChangelogPage.routeName: (_) => const ChangelogPage(),
        DonatePage.routeName: (_) => const DonatePage(),
        HelpTranslatePage.routeName: (_) => const HelpTranslatePage(),
        OneSignalDataPrivacyPage.routeName: (_) =>
            const OneSignalDataPrivacyPage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
      },
      initialRoute: '/settings',
    );
  }
}
