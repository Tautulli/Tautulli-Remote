import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_alert_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../../onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import '../../../../onesignal/presentation/pages/cupertino/cupertino_style_onesignal_data_privacy_page.dart';
import '../../bloc/settings_bloc.dart';

class CupertinoStyleOnesignalAlertCard extends StatelessWidget {
  const CupertinoStyleOnesignalAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
      builder: (context, privacyState) {
        // If OneSignal consent is false
        if (privacyState is OneSignalPrivacyFailure) {
          return CupertinoStyleAlertCard(
            tint: CupertinoColors.systemOrange.highContrastColor,
            leading: const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 30,
              color: ThemeHelper.cupertinoAlertCardIconColor,
            ),
            title: LocaleKeys.onesignal_data_privacy_not_accepted_title.tr(),
            content: LocaleKeys.onesignal_data_privacy_not_accepted_content.tr(),
            actions: [
              CupertinoButton(
                child: const Text(
                  LocaleKeys.dismiss_title,
                  style: TextStyle(
                    color: ThemeHelper.cupertinoAlertCardButtonTextColor,
                  ),
                ).tr(),
                onPressed: () => settingsBloc.add(
                  const SettingsUpdateOneSignalBannerDismiss(true),
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
                    builder: (context) => CupertinoStyleOnesignalDataPrivacyPage(
                      previousPageTitle: LocaleKeys.settings_title.tr(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // If OneSignal consent is true
        return BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
          builder: (context, healthState) {
            // If OneSignal is not reachable
            if (healthState is OneSignalHealthFailure) {
              return CupertinoStyleAlertCard(
                leading: const FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 30,
                  color: ThemeHelper.cupertinoAlertCardIconColor,
                ),
                title: LocaleKeys.onesignal_unreachable_title.tr(),
                content: LocaleKeys.onesignal_unreachable_content.tr(),
                actions: [
                  CupertinoButton(
                    child: const Text(
                      LocaleKeys.check_again_title,
                      style: TextStyle(
                        color: ThemeHelper.cupertinoAlertCardButtonTextColor,
                      ),
                    ).tr(),
                    onPressed: () => context.read<OneSignalHealthBloc>().add(
                      OneSignalHealthCheck(),
                    ),
                  ),
                ],
              );
            }

            // If OneSignal is reachable
            return BlocBuilder<OneSignalSubBloc, OneSignalSubState>(
              builder: (context, subState) {
                // If OneSignal is not subscribed
                if (subState is OneSignalSubFailure) {
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
                            'https://github.com/Tautulli/Tautulli-Remote/wiki/OneSignal#registering',
                          );
                        },
                      ),
                    ],
                  );
                }

                // If OneSignal is Subscribed
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
