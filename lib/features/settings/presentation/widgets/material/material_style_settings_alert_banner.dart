import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/requirements/tautulli_version.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../push/presentation/bloc/push_health_bloc.dart';
import '../../../../push/presentation/bloc/push_privacy_bloc.dart';
import '../../../../push/presentation/bloc/push_sub_bloc.dart';
import '../../../domain/usecases/settings.dart';
import '../../bloc/settings_bloc.dart';

class MaterialStyleSettingsAlertBanner extends StatelessWidget {
  const MaterialStyleSettingsAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<PushPrivacyBloc, PushPrivacyState>(
      builder: (context, privacyState) {
        // If notification consent is false
        if (privacyState is PushPrivacyFailure) {
          return _SettingsAlertBannerContent(
            backgroundColor: Colors.deepOrange[900],
            title: LocaleKeys.notifications_data_privacy_not_accepted_title.tr(),
            message: const Text(
              LocaleKeys.notifications_data_privacy_not_accepted_content,
              style: TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
            ).tr(),
            buttonOne: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: TautulliColorPalette.notWhite,
              ),
              onPressed: () => settingsBloc.add(
                const SettingsUpdateNotificationsBannerDismiss(true),
              ),
              child: const Text(LocaleKeys.dismiss_button).tr(),
            ),
            buttonTwo: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: TautulliColorPalette.notWhite,
              ),
              onPressed: () => Navigator.of(context).pushNamed('/notifications_privacy'),
              child: const Text(LocaleKeys.view_privacy_page_title).tr(),
            ),
          );
        }

        // If notification consent is true
        return BlocBuilder<PushHealthBloc, PushHealthState>(
          builder: (context, healthState) {
            // If the push relay is not reachable
            if (healthState is PushHealthFailure) {
              return _SettingsAlertBannerContent(
                title: LocaleKeys.notifications_unreachable_title.tr(),
                message: const Text(
                  LocaleKeys.notifications_unreachable_content,
                  style: TextStyle(
                    color: TautulliColorPalette.notWhite,
                  ),
                ).tr(),
                buttonOne: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: TautulliColorPalette.notWhite,
                  ),
                  onPressed: () => context.read<PushHealthBloc>().add(
                    PushHealthCheck(),
                  ),
                  child: const Text(LocaleKeys.check_again_title).tr(),
                ),
              );
            }

            // If the push relay is reachable
            return BlocBuilder<PushSubBloc, PushSubState>(
              builder: (context, subState) {
                // If this device is not subscribed, either because the notification permission is
                // missing or because registration has not completed
                if (subState is PushSubFailure) {
                  return _SettingsAlertBannerContent(
                    backgroundColor: Colors.deepOrange[900],
                    title: subState.title,
                    message: Text(
                      subState.message,
                      style: const TextStyle(
                        color: TautulliColorPalette.notWhite,
                      ),
                    ),
                    buttonOne: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: TautulliColorPalette.notWhite,
                      ),
                      onPressed: () async {
                        await launchUrlString(
                          mode: LaunchMode.externalApplication,
                          'https://github.com/Tautulli/Tautulli-Remote/wiki/Notifications#registering-for-notifications',
                        );
                      },
                      child: const Text(LocaleKeys.learn_more_title).tr(),
                    ),
                  );
                }

                // If this device is subscribed but a server is too old to
                // deliver through the relay
                return BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settingsState) {
                    final outdatedServers = _serversWithoutPush(settingsState);
                    if (outdatedServers.isEmpty) {
                      // All checks passed do not display banner
                      return const SizedBox(height: 0, width: 0);
                    }

                    return _SettingsAlertBannerContent(
                      // Orange, matching the Cupertino card and the sibling
                      // "not subscribed" banner: something needs attention, but
                      // notifications are not broken yet.
                      backgroundColor: Colors.deepOrange[900],
                      title: LocaleKeys.notifications_server_outdated_title.tr(),
                      message: Text(
                        LocaleKeys.notifications_server_outdated_content.tr(
                          args: [
                            outdatedServers.map((server) => server.plexName).join(', '),
                            MinimumVersion.tautulliServerPush.toString(),
                          ],
                        ),
                        style: const TextStyle(
                          color: TautulliColorPalette.notWhite,
                        ),
                      ),
                      buttonOne: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: TautulliColorPalette.notWhite,
                        ),
                        onPressed: () async {
                          await launchUrlString(
                            mode: LaunchMode.externalApplication,
                            'https://github.com/Tautulli/Tautulli-Remote/wiki/Notifications#tautulli-server-version',
                          );
                        },
                        child: const Text(LocaleKeys.learn_more_title).tr(),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Servers whose Tautulli cannot deliver through the relay.
///
/// Takes the settings state rather than reading the bloc, so the caller has to
/// subscribe to it: both settings pages hand this widget over as a `const`
/// instance, and Flutter short-circuits an identical child, so a banner derived
/// from a non-subscribing read would freeze at whatever the first build computed
/// and keep naming a server the user had since deleted.
///
/// Recomputed from the version each server reported at its last registration
/// rather than read from the stored `pushRegistered` flag, so that raising
/// [MinimumVersion.tautulliServerPush] in an app update takes effect on the next
/// build instead of waiting for every server to re-register. A server with no
/// recorded version is left alone, matching [MinimumVersion.supportsPush]'s
/// decision to fail open rather than warn about something it cannot read.
List<ServerModel> _serversWithoutPush(SettingsState settingsState) {
  if (settingsState is! SettingsSuccess) return const [];

  return settingsState.serverList.where((server) {
    final version = di.sl<Settings>().getLastRegisteredServerVersion(server.tautulliId);
    return version != null && !MinimumVersion.supportsPush(version);
  }).toList();
}

class _SettingsAlertBannerContent extends StatelessWidget {
  final Color? backgroundColor;
  final String title;
  final Widget? message;
  final TextButton? buttonOne;
  final TextButton? buttonTwo;

  const _SettingsAlertBannerContent({
    this.backgroundColor,
    required this.title,
    this.message,
    this.buttonOne,
    this.buttonTwo,
  }) : assert(buttonOne != null || buttonTwo != null);

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      forceActionsBelow: true,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.errorContainer,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      leading: const FaIcon(
        FontAwesomeIcons.triangleExclamation,
        size: 30,
        color: TautulliColorPalette.notWhite,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: TautulliColorPalette.notWhite,
            ),
          ),
          ?message,
        ],
      ),
      actions: [
        ?buttonOne,
        ?buttonTwo,
      ],
    );
  }
}
