import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:f_logs/f_logs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_actions/quick_actions.dart';

import 'app_framework.dart';
import 'features/settings/data/models/register_device_model.dart';
import 'core/database/data/models/server_model.dart';
import 'core/error/failure.dart';
import 'core/global_keys/global_keys.dart';
import 'core/helpers/notification_helper.dart';
import 'core/helpers/quick_actions_helper.dart';
import 'core/package_information/package_information.dart';
import 'core/requirements/tautulli_version.dart';
import 'core/types/app_style.dart';
import 'dependency_injection.dart' as di;
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/history/presentation/pages/material/material_style_history_page.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/push/data/datasources/push_data_source.dart';
import 'features/push/domain/usecases/push.dart';
import 'features/push/presentation/bloc/push_health_bloc.dart';
import 'features/push/presentation/bloc/push_privacy_bloc.dart';
import 'features/push/presentation/bloc/push_sub_bloc.dart';
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
    initializePush();
    initializeFLogConfiguration();
    checkForAppUpdate();
    checkIfRegistrationUpdateNeeded();

    context.read<PushPrivacyBloc>().add(PushPrivacyCheck());
    // Delay the subscription check on app start to give messaging time to
    // finish initialising and hand back a token.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.read<PushSubBloc>().add(PushSubCheck());
    });
    context.read<AnnouncementsBloc>().add(AnnouncementsFetch());
  }

  Future<void> initializePush() async {
    if (!mounted) return;

    final messaging = di.sl<FirebaseMessaging>();

    // Nothing is requested until the user has accepted the data privacy notice,
    // which is what the wizard and the privacy page ask for.
    if (di.sl<Settings>().getNotificationsConsented()) {
      await messaging.requestPermission();
      await messaging.setAutoInitEnabled(true);
    }

    // A notification tapped while the app was terminated is waiting here.
    if (Platform.isIOS) {
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        await _handleRemoteMessage(initialMessage);
      }

      FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessage);

      // Android builds and posts its own notifications, so the foreground
      // presentation options only apply here.
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: false,
        sound: true,
      );
    } else {
      _listenForAndroidNotificationTaps();
    }

    // A rotated token can no longer be delivered to, so every server the app is
    // registered with needs the new one.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      if (!mounted) return;

      context.read<PushSubBloc>().add(PushSubCheck());
      context.read<PushHealthBloc>().add(PushHealthCheck());

      await pushRegistrationChange();
    });

    // A refresh that happened while the app was closed is only visible by
    // comparing what was last registered against the token held now — on
    // Android our own messaging service records it, and the listener above
    // never fires for it.
    await checkIfPushTokenChanged();
  }

  /// Android posts notifications natively, so a tap arrives over a platform
  /// channel rather than through the messaging plugin.
  void _listenForAndroidNotificationTaps() {
    const channel = MethodChannel('com.tautulli.tautulli_remote/notification_tap');

    channel.setMethodCallHandler((call) async {
      if (call.method == 'onNotificationTapped') {
        final arguments = Map<String, dynamic>.from(call.arguments as Map);
        await _handleNotificationAction(arguments['action'] as String?);
      }
    });

    // Collect the tap that launched the app, if there was one. Guarded because
    // an unanswered channel throws, and an unhandled error here would be
    // reported as a fatal crash on every single launch.
    channel.invokeMapMethod<String, dynamic>('getLaunchNotification').then((launch) async {
      if (launch != null) {
        await _handleNotificationAction(launch['action'] as String?);
      }
    }).catchError((Object e) {
      di.sl<Logging>().warning('Notifications :: Unable to read the launching notification [$e]');
    });
  }

  Future<void> _handleRemoteMessage(RemoteMessage message) async {
    final payload = NotificationHelper.unwrapPayload(message.data);

    // The iOS extension decrypts on arrival and caches the action, which spares
    // repeating the key derivation here just to decide where to navigate.
    String? action = await NotificationHelper.readCachedAction(payload?['server_id']);

    action ??= (await NotificationHelper.extractAdditionalData(payload))?['action'];

    await _handleNotificationAction(action);
  }

  Future<void> _handleNotificationAction(String? action) async {
    if (action == null || action.isEmpty) return;

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

  /// Re-registers every server when the push token differs from the one last
  /// sent, which covers a refresh that happened while the app was not running.
  Future<void> checkIfPushTokenChanged() async {
    //! Wait for SettingsBloc to be SettingsSuccess
    // Checked before subscribing: this runs after several awaits, so the state
    // has usually already arrived, and firstWhere on a stream that has already
    // emitted would wait for a second event that never comes.
    final settingsBloc = context.read<SettingsBloc>();
    if (settingsBloc.state is! SettingsSuccess) {
      await settingsBloc.stream.firstWhere((state) => state is SettingsSuccess);
    }

    final token = await di.sl<Push>().token;
    if (token == pushDisabled) return;

    if (di.sl<Settings>().getLastRegisteredPushToken() == token) return;

    di.sl<Logging>().info('Notifications :: Push token changed, updating server registration');

    await pushRegistrationChange();
  }

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

  Future<void> pushRegistrationChange() async {
    final servers = await di.sl<Settings>().getAllServers();

    di.sl<Logging>().info(
      'Notifications :: Push registration changed, updating server registration in 5 seconds',
    );

    await Future.delayed(const Duration(seconds: 5));

    final token = await di.sl<Push>().token;
    // Tracks whether every server actually took the registration. A server too
    // old to store a push token still counts: it accepted what it was given,
    // and treating that as failure would re-register on every launch forever,
    // for as long as the user stays on that Tautulli version.
    // With no servers there is nowhere to hand the token, so it must not be
    // recorded as registered: doing so would skip the check on later launches
    // and leave a server added afterwards without a token.
    bool allAccepted = servers.isNotEmpty;

    for (ServerModel server in servers) {
      final failureOrRegisterDevice = await updateServerRegistration(server);

      // Either.fold does not await async callbacks — use if/else so the
      // await on updateServer is properly sequenced before setRegistrationUpdateNeeded.
      if (failureOrRegisterDevice.isLeft()) {
        allAccepted = false;

        di.sl<Logging>().error(
          'Notifications :: Failed to update registration for ${server.plexName} with push token',
        );
      } else {
        // A server too old to store the push token accepts the registration but
        // has nowhere to put it, so it must not be recorded as registered.
        final registerDevice = failureOrRegisterDevice.toOption().toNullable();
        final supportsPush =
            token != pushDisabled && MinimumVersion.supportsPush(registerDevice?.value1.tautulliVersion);

        await di.sl<Settings>().updateServer(
          server.copyWith(pushRegistered: supportsPush),
        );

        di.sl<Logging>().info(
          'Notifications :: Updated registration for ${server.plexName} with push token',
        );

        di.sl<Settings>().setRegistrationUpdateNeeded(false);
      }
    }

    // Only remember the token once every server has taken it, so a partial
    // failure is retried on the next launch instead of being forgotten.
    if (allAccepted && token != pushDisabled) {
      await di.sl<Settings>().setLastRegisteredPushToken(token);
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
