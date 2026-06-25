import 'package:app_version_update/app_version_update.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quick_actions/quick_actions.dart';

import 'app_framework.dart';
import 'core/api/tautulli/models/register_device_model.dart';
import 'core/database/data/models/server_model.dart';
import 'core/error/failure.dart';
import 'core/global_keys/global_keys.dart';
import 'core/helpers/notification_helper.dart';
import 'core/helpers/quick_actions_helper.dart';
import 'core/package_information/package_information.dart';
import 'core/types/app_style.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/history/presentation/pages/material/material_style_history_page.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/recently_added/presentation/pages/material/material_style_recently_added_page.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

class TautulliRemote extends StatefulWidget {
  const TautulliRemote({super.key});

  @override
  TautulliRemoteState createState() => TautulliRemoteState();
}

class TautulliRemoteState extends State<TautulliRemote> {

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsLoad());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeQuickActions(const QuickActions());
    });
    initializeOneSignal();
    initializeFLogConfiguration();
    checkForAppUpdate();
    checkIfRegistrationUpdateNeeded();

    context.read<OneSignalPrivacyBloc>().add(OneSignalPrivacyCheck());
    // Delay OneSignalSubCheck on app start to avoid calling OSDeviceState
    // before OneSignal is fully initalized
    Future.delayed(const Duration(seconds: 2), () {
      context.read<OneSignalSubBloc>().add(OneSignalSubCheck());
    });
    context.read<AnnouncementsBloc>().add(AnnouncementsFetch());
  }

  Future<void> initializeOneSignal() async {
    if (!mounted) return;

    // Enabling console logs for users to troubleshoot OneSignal issues
    await OneSignal.Debug.setLogLevel(OSLogLevel.error);

    OneSignal.consentRequired(true);

    OneSignal.initialize("3b4b666a-d557-4b92-acdf-e2c8c4b95357");

    await OneSignal.Location.setShared(false);

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      /// preventDefault to not display the notification
      // event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();
    });

    OneSignal.Notifications.addClickListener((event) async {
      // Will be called whenever a notification is opened/button pressed

      final additionalData = event.notification.additionalData;

      // On iOS the NotificationServiceExtension pre-decrypts and caches the
      // action, so we can skip the expensive PBKDF2 derivation here.
      String? action = await NotificationHelper.readCachedAction(
        additionalData?['server_id'],
      );

      // Fall back to full decryption (always used on Android; iOS fallback
      // when the extension didn't run or the cache wasn't written).
      if (action == null) {
        final data = await NotificationHelper.extractAdditionalData(additionalData);
        action = data?['action'];
      }

      if (action != null) {
        // Add small delay to help make sure navigatorKey is not null
        await Future.delayed(const Duration(milliseconds: 10));

        final isCupertino = currentAppStyle == AppStyle.cupertino;

        if (isCupertino) {
          switch (action) {
            case ('watched'):
              historyRefreshNotifier.value = true;
              cupertinoTabController.index = 1;
              return;
            case ('created'):
              recentlyAddedRefreshNotifier.value = true;
              cupertinoTabController.index = 2;
              return;
            default:
              cupertinoTabController.index = 0;
          }
        } else {
          switch (action) {
            case ('watched'):
              navigatorKey.currentState?.pushReplacementNamed(
                MaterialStyleHistoryPage.routeName,
                arguments: {'refreshOnLoad': true},
              );
              return;
            case ('created'):
              navigatorKey.currentState?.pushReplacementNamed(
                MaterialStyleRecentlyAddedPage.routeName,
                arguments: {'refreshOnLoad': true},
              );
              return;
            default:
              navigatorKey.currentState?.pushReplacementNamed('/activity');
          }
        }
      }
    });


    OneSignal.User.pushSubscription.addObserver((state) async {
      // Will be called whenever the subscription changes
      if (!mounted) return;

      OSPushSubscriptionState current = state.current;
      OSPushSubscriptionState previous = state.previous;

      // Only trigger new checks when userId or pushToken move from null to a value
      if (current.id != previous.id || current.token != previous.token) {
        context.read<OneSignalSubBloc>().add(OneSignalSubCheck());
        context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());

        if (current.id != previous.id) {
          await oneSignalServerRegistrationChange();
        }
      }
    });

    // Check if registration update is needed after OneSignal is initalized to avoid sending a blank User ID
    // await veryifyOneSignalConsent();
    checkIfRegistrationUpdateNeeded();
  }

  // Future<void> veryifyOneSignalConsent() async {
  //   //! Wait for SettingsBloc to be SettingsSuccess
  //   await context.read<SettingsBloc>().stream.firstWhere((state) => state is SettingsSuccess);

  //   if (di.sl<Settings>().getOneSignalConsented() == true && await OneSignal.shared.userProvidedPrivacyConsent() == false) {
  //     await Future.delayed(const Duration(seconds: 1)).then((value) async {
  //       context.read<OneSignalPrivacyBloc>().add(
  //             OneSignalPrivacyReGrant(
  //               settingsBloc: context.read<SettingsBloc>(),
  //             ),
  //           );

  //       await Future.delayed(const Duration(seconds: 1)).then(
  //         (value) async => await oneSignalServerRegistrationChange(),
  //       );

  //       di.sl<Settings>().setRegistrationUpdateNeeded(false);
  //     });
  //   }

  //   return Future.value();
  // }

  void initializeFLogConfiguration() {
    FLog.applyConfigurations(
      LogsConfig()..activeLogLevel = LogLevel.ALL,
    );
  }

  Future<void> checkForAppUpdate() async {
    //! Wait for SettingsBloc to be SettingsSuccess
    await context.read<SettingsBloc>().stream.firstWhere((state) => state is SettingsSuccess);

    try {
      final data = await AppVersionUpdate.checkForUpdates(
        appleId: '1570909086',
        playStoreId: 'com.tautulli.tautulli_remote',
      );

      if (data.canUpdate != null) {
        if (data.canUpdate == true) {
          di.sl<Logging>().info(
            'App Update :: Update available. Local Version: ${await di.sl<PackageInformation>().version} | Store Version: ${data.storeVersion}',
          );
        }

        if (!mounted) return;
        context.read<SettingsBloc>().add(
          SettingsUpdateAppUpdateAvailable(
            appUpdateAvailable: data.canUpdate!,
          ),
        );
      }
    } catch (e) {
      di.sl<Logging>().warning('App Update :: Failed to check for updates [$e]');
    }
  }

  Future<void> checkIfRegistrationUpdateNeeded() async {
    //! Wait for SettingsBloc to be SettingsSuccess
    await context.read<SettingsBloc>().stream.firstWhere((state) => state is SettingsSuccess);

    if (di.sl<Settings>().getRegistrationUpdateNeeded()) {
      final servers = await di.sl<Settings>().getAllServers();

      if (servers.isNotEmpty) {
        di.sl<Logging>().info(
          'Settings :: App version changed, updating server registration',
        );

        for (ServerModel server in servers) {
          final failureOrRegisterDevice = await updateServerRegistration(server);

          // Either.fold does not await async callbacks — use if/else so the
          // await on updateServer is properly sequenced before setRegistrationUpdateNeeded.
          if (failureOrRegisterDevice.isLeft()) {
            di.sl<Logging>().error(
              'Settings :: Failed to update registration for ${server.plexName} with new app version',
            );
          } else {
            await di.sl<Settings>().updateServer(server);

            di.sl<Logging>().info(
              'Settings :: Updated registration for ${server.plexName} with new app version',
            );

            di.sl<Settings>().setRegistrationUpdateNeeded(false);
          }
        }
      }
    }
  }

  Future<void> oneSignalServerRegistrationChange() async {
    final servers = await di.sl<Settings>().getAllServers();

    di.sl<Logging>().info(
      'OneSignal :: OneSignal registration changed, updating server registration in 5 seconds',
    );

    await Future.delayed(const Duration(seconds: 5));

    for (ServerModel server in servers) {
      final failureOrRegisterDevice = await updateServerRegistration(server);

      // Either.fold does not await async callbacks — use if/else so the
      // await on updateServer is properly sequenced before setRegistrationUpdateNeeded.
      if (failureOrRegisterDevice.isLeft()) {
        di.sl<Logging>().error(
          'OneSignal :: Failed to update registration for ${server.plexName} with OneSignal ID',
        );
      } else {
        await di.sl<Settings>().updateServer(
          server.copyWith(oneSignalRegistered: true),
        );

        di.sl<Logging>().info(
          'OneSignal :: Updated registration for ${server.plexName} with OneSignal ID',
        );

        di.sl<Settings>().setRegistrationUpdateNeeded(false);
      }
    }
  }

  Future<dartz.Either<Failure, dartz.Tuple2<RegisterDeviceModel, bool>>> updateServerRegistration(
    ServerModel server,
  ) async {
    final bool usePrimary = server.primaryActive ?? true;
    final bool secondaryAvailable =
        server.secondaryConnectionProtocol != null && server.secondaryConnectionDomain != null;

    if (!usePrimary && !secondaryAvailable) {
      di.sl<Logging>().warning(
        'TautulliRemote :: Secondary connection details missing for ${server.plexName} — falling back to primary for registration update',
      );
    }

    final bool useSecondary = !usePrimary && secondaryAvailable;

    String connectionProtocol =
        useSecondary ? server.secondaryConnectionProtocol! : server.primaryConnectionProtocol;
    String connectionDomain =
        useSecondary ? server.secondaryConnectionDomain! : server.primaryConnectionDomain;
    String? connectionPath = useSecondary ? server.secondaryConnectionPath : server.primaryConnectionPath;

    final failureOrRegisterDevice = await di.sl<Settings>().registerDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath ?? '',
      deviceToken: server.deviceToken,
      customHeaders: server.customHeaders,
    );

    return failureOrRegisterDevice;
  }

  @override
  Widget build(BuildContext context) {
    return const AppFramework();
  }
}
