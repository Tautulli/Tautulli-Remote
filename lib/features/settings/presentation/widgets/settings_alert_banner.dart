import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import '../bloc/settings_bloc.dart';

class SettingsAlertBanner extends StatelessWidget {
  const SettingsAlertBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
      builder: (context, privacyState) {
        // If OneSignal consent is false
        if (privacyState is OneSignalPrivacyFailure) {
          return _SettingsAlertBannerContent(
            backgroundColor: Colors.deepOrange[900],
            title: 'OneSignal Data Privacy Not Accepted',
            message: const Text(
              'To receive notifications from Tautulli consent to the OneSignal data privacy is required.',
            ),
            buttonOne: TextButton(
              child: const Text('DISMISS'),
              onPressed: () => settingsBloc.add(
                const SettingsUpdateOneSignalBannerDismiss(true),
              ),
            ),
            buttonTwo: TextButton(
              child: const Text('VIEW PRIVACY PAGE'),
              onPressed: () =>
                  Navigator.of(context).pushNamed('/onesignal_privacy'),
            ),
          );
        }

        // If OneSignal consent is true
        return BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
          builder: (context, healthState) {
            // If OneSignal is not reachable
            if (healthState is OneSignalHealthFailure) {
              return _SettingsAlertBannerContent(
                title: 'Unable to reach OneSignal',
                message: const Text(
                  'In this state notifications will not work and Tautulli Remote will be unable to register with OneSignal.',
                ),
                buttonOne: TextButton(
                  child: const Text('CHECK AGAIN'),
                  onPressed: () => context.read<OneSignalHealthBloc>().add(
                        OneSignalHealthCheck(),
                      ),
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
                    message: Text(subState.message),
                    buttonOne: TextButton(
                      child: const Text('LEARN MORE'),
                      onPressed: () async {
                        await launch(
                          'https://github.com/Tautulli/Tautulli-Remote/wiki/OneSignal#registering',
                        );
                      },
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
    Key? key,
    this.backgroundColor,
    required this.title,
    this.message,
    this.buttonOne,
    this.buttonTwo,
  })  : assert(buttonOne != null || buttonTwo != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      forceActionsBelow: true,
      backgroundColor: backgroundColor ?? Colors.red[900],
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      leading: const FaIcon(
        FontAwesomeIcons.exclamationTriangle,
        size: 30,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
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
