import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/requirements/tautulli_version.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../core/widgets/cupertino/cupertino_style_alert_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../push/presentation/bloc/push_health_bloc.dart';
import '../../../../push/presentation/bloc/push_privacy_bloc.dart';
import '../../../../push/presentation/bloc/push_sub_bloc.dart';
import '../../../../push/presentation/pages/cupertino/cupertino_style_notifications_privacy_page.dart';
import '../../../domain/usecases/settings.dart';
import '../../bloc/settings_bloc.dart';

class CupertinoStyleNotificationsAlertCard extends StatelessWidget {
  const CupertinoStyleNotificationsAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<PushPrivacyBloc, PushPrivacyState>(
      builder: (context, privacyState) {
        // If notification consent is false
        if (privacyState is PushPrivacyFailure) {
          return CupertinoStyleAlertCard(
            tint: CupertinoColors.systemOrange.highContrastColor,
            leading: const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 30,
              color: ThemeHelper.cupertinoAlertCardIconColor,
            ),
            title: LocaleKeys.notifications_data_privacy_not_accepted_title.tr(),
            content: LocaleKeys.notifications_data_privacy_not_accepted_content.tr(),
            actions: [
              CupertinoButton(
                child: const Text(
                  LocaleKeys.dismiss_title,
                  style: TextStyle(
                    color: ThemeHelper.cupertinoAlertCardButtonTextColor,
                  ),
                ).tr(),
                onPressed: () => settingsBloc.add(
                  const SettingsUpdateNotificationsBannerDismiss(true),
                ),
              ),
              CupertinoButton(
                child: const Text(
                  LocaleKeys.view_privacy_page_title,
                  style: TextStyle(
                    color: ThemeHelper.cupertinoAlertCardButtonTextColor,
                  ),
                ).tr(),
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CupertinoStyleNotificationsPrivacyPage(
                      previousPageTitle: LocaleKeys.settings_title.tr(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // If notification consent is true
        return BlocBuilder<PushHealthBloc, PushHealthState>(
          builder: (context, healthState) {
            // If the push relay is not reachable
            if (healthState is PushHealthFailure) {
              return CupertinoStyleAlertCard(
                leading: const FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 30,
                  color: ThemeHelper.cupertinoAlertCardIconColor,
                ),
                title: LocaleKeys.notifications_unreachable_title.tr(),
                content: LocaleKeys.notifications_unreachable_content.tr(),
                actions: [
                  CupertinoButton(
                    child: const Text(
                      LocaleKeys.check_again_title,
                      style: TextStyle(
                        color: ThemeHelper.cupertinoAlertCardButtonTextColor,
                      ),
                    ).tr(),
                    onPressed: () => context.read<PushHealthBloc>().add(
                      PushHealthCheck(),
                    ),
                  ),
                ],
              );
            }

            // If the push relay is reachable
            return BlocBuilder<PushSubBloc, PushSubState>(
              builder: (context, subState) {
                // If this device is not subscribed, either because the notification permission is
                // missing or because registration has not completed
                if (subState is PushSubFailure) {
                  return CupertinoStyleAlertCard(
                    tint: CupertinoColors.systemOrange.highContrastColor,
                    leading: const FaIcon(
                      FontAwesomeIcons.triangleExclamation,
                      size: 30,
                      color: ThemeHelper.cupertinoAlertCardIconColor,
                    ),
                    title: subState.title,
                    content: subState.message,
                    actions: [
                      CupertinoButton(
                        child: const Text(
                          LocaleKeys.learn_more_title,
                          style: TextStyle(
                            color: ThemeHelper.cupertinoAlertCardButtonTextColor,
                          ),
                        ).tr(),
                        onPressed: () async {
                          await launchUrlString(
                            mode: LaunchMode.externalApplication,
                            'https://github.com/Tautulli/Tautulli-Remote/wiki/Notifications#registering-for-notifications',
                          );
                        },
                      ),
                    ],
                  );
                }

                // If this device is subscribed but a server is too old to
                // deliver through the relay
                return BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settingsState) {
                    final outdatedServers = _serversWithoutPush(settingsState);
                    if (outdatedServers.isEmpty) {
                      // All checks passed do not display banner
                      return const SizedBox();
                    }

                    return CupertinoStyleAlertCard(
                      tint: CupertinoColors.systemOrange.highContrastColor,
                      leading: const FaIcon(
                        FontAwesomeIcons.triangleExclamation,
                        size: 30,
                        color: ThemeHelper.cupertinoAlertCardIconColor,
                      ),
                      title: LocaleKeys.notifications_server_outdated_title.tr(),
                      content: LocaleKeys.notifications_server_outdated_content.tr(
                        args: [
                          outdatedServers.map((server) => server.plexName).join(', '),
                          MinimumVersion.tautulliServerPush.toString(),
                        ],
                      ),
                      actions: [
                        CupertinoButton(
                          child: const Text(
                            LocaleKeys.learn_more_title,
                            style: TextStyle(
                              color: ThemeHelper.cupertinoAlertCardButtonTextColor,
                            ),
                          ).tr(),
                          onPressed: () async {
                            await launchUrlString(
                              mode: LaunchMode.externalApplication,
                              'https://github.com/Tautulli/Tautulli-Remote/wiki/Notifications#tautulli-server-version',
                            );
                          },
                        ),
                      ],
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
