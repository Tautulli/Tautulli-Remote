import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import '../bloc/settings_bloc.dart';

class SettingsAlertBanner extends StatelessWidget {
  const SettingsAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
      builder: (context, privacyState) {
        // If OneSignal consent is false
        if (privacyState is OneSignalPrivacyFailure) {
          return _SettingsAlertBannerContent(
            backgroundColor: Colors.deepOrange[900],
            title: LocaleKeys.onesignal_data_privacy_not_accepted_title.tr(),
            message: const Text(
              LocaleKeys.onesignal_data_privacy_not_accepted_content,
              style: TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
            ).tr(),
            buttonOne: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: TautulliColorPalette.notWhite,
              ),
              onPressed: () => settingsBloc.add(
                const SettingsUpdateOneSignalBannerDismiss(true),
              ),
              child: const Text(LocaleKeys.dismiss_buttom).tr(),
            ),
            buttonTwo: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: TautulliColorPalette.notWhite,
              ),
              onPressed: () => Navigator.of(context).pushNamed('/onesignal_privacy'),
              child: const Text(LocaleKeys.view_privacy_page_title).tr(),
            ),
          );
        }

        // If OneSignal consent is true
        return BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
          builder: (context, healthState) {
            // If OneSignal is not reachable
            if (healthState is OneSignalHealthFailure) {
              return _SettingsAlertBannerContent(
                title: LocaleKeys.onesignal_unreachable_title.tr(),
                message: const Text(
                  LocaleKeys.onesignal_unreachable_content,
                  style: TextStyle(
                    color: TautulliColorPalette.notWhite,
                  ),
                ).tr(),
                buttonOne: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: TautulliColorPalette.notWhite,
                  ),
                  onPressed: () => context.read<OneSignalHealthBloc>().add(
                        OneSignalHealthCheck(),
                      ),
                  child: const Text(LocaleKeys.check_again_title).tr(),
                ),
              );
            }

            // If OneSignal is reachable
            return BlocBuilder<OneSignalSubBloc, OneSignalSubState>(
              builder: (context, subState) {
                // If OneSignal is not subscribed
                if (subState is OneSignalSubFailure) {
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
                          'https://github.com/Tautulli/Tautulli-Remote/wiki/OneSignal#registering',
                        );
                      },
                      child: const Text(LocaleKeys.learn_more_title).tr(),
                    ),
                  );
                }

                // If OneSignal is Subscribed
                // All checks passed do not display banner
                return const SizedBox(height: 0, width: 0);
              },
            );
          },
        );
      },
    );
  }
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
          if (message != null) message!,
        ],
      ),
      actions: [
        if (buttonOne != null) buttonOne!,
        if (buttonTwo != null) buttonTwo!,
      ],
    );
  }
}
