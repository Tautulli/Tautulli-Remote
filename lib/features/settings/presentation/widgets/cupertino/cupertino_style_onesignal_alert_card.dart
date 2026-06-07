import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote/features/onesignal/presentation/pages/ios/onesignal_data_privacy_ios_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/cupertino_alert_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../../onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import '../../bloc/settings_bloc.dart';

class CupertinoStyleOnesignalAlertCard extends StatelessWidget {
  const CupertinoStyleOnesignalAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
      builder: (context, privacyState) {
        // If OneSignal consent is false
        if (privacyState is OneSignalPrivacyFailure) {
          return CupertinoAlertCard(
            tint: CupertinoColors.systemOrange.highContrastColor,
            leading: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 30,
              color: ThemeHelper.cupertinoAlertCardIconColor(),
            ),
            title: LocaleKeys.onesignal_data_privacy_not_accepted_title.tr(),
            content: LocaleKeys.onesignal_data_privacy_not_accepted_content.tr(),
            actions: [
              CupertinoButton(
                //TODO: "Dismiss" translation strong. LocaleKeys.dismiss_buttom is mispelled
                child: Text(
                  'Dismiss',
                  style: TextStyle(
                    color: ThemeHelper.cupertinoAlertCardButtonTextColor(),
                  ),
                ),
                onPressed: () => settingsBloc.add(
                  const SettingsUpdateOneSignalBannerDismiss(true),
                ),
              ),
              CupertinoButton(
                child: Text(
                  LocaleKeys.view_privacy_page_title,
                  style: TextStyle(
                    color: ThemeHelper.cupertinoAlertCardButtonTextColor(),
                  ),
                ).tr(),
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => OneSignalDataPrivacyIosPage(
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
              return CupertinoAlertCard(
                leading: FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 30,
                  color: ThemeHelper.cupertinoAlertCardIconColor(),
                ),
                title: LocaleKeys.onesignal_unreachable_title.tr(),
                content: LocaleKeys.onesignal_unreachable_content.tr(),
                actions: [
                  CupertinoButton(
                    child: Text(
                      LocaleKeys.check_again_title,
                      style: TextStyle(
                        color: ThemeHelper.cupertinoAlertCardButtonTextColor(),
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
                  return CupertinoAlertCard(
                    tint: CupertinoColors.systemOrange.highContrastColor,
                    leading: FaIcon(
                      FontAwesomeIcons.triangleExclamation,
                      size: 30,
                      color: ThemeHelper.cupertinoAlertCardIconColor(),
                    ),
                    title: subState.title,
                    content: subState.message,
                    actions: [
                      CupertinoButton(
                        child: Text(
                          LocaleKeys.learn_more_title,
                          style: TextStyle(
                            color: ThemeHelper.cupertinoAlertCardButtonTextColor(),
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
