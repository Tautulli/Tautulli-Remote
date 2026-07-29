import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_alert_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../push/presentation/bloc/push_health_bloc.dart';
import '../../../../push/presentation/bloc/push_privacy_bloc.dart';
import '../../../../push/presentation/bloc/push_sub_bloc.dart';
import '../../../../push/presentation/pages/cupertino/cupertino_style_notifications_privacy_page.dart';
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
                            'https://github.com/Tautulli/Tautulli-Remote/wiki/Notifications#registering',
                          );
                        },
                      ),
                    ],
                  );
                }

                // If this device is subscribed
                // All checks passed do not display banner
                return const SizedBox();
              },
            );
          },
        );
      },
    );
  }
}
