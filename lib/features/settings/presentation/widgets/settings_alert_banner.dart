import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../bloc/settings_bloc.dart';

class SettingsAlertBanner extends StatelessWidget {
  const SettingsAlertBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = context.read<OneSignalPrivacyBloc>();
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadSuccess) {
          return BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
            builder: (context, healthState) {
              return BlocBuilder<OneSignalSubscriptionBloc,
                  OneSignalSubscriptionState>(
                builder: (context, subscriptionState) {
                  // Display alert banner about consenting to privacy policy
                  if (!state.oneSignalBannerDismissed &&
                      oneSignalPrivacyBloc.state
                          is OneSignalPrivacyConsentFailure) {
                    if (subscriptionState is OneSignalSubscriptionFailure) {
                      return _AlertBanner(
                        title: subscriptionState.title,
                        message: Text(
                          subscriptionState.message,
                        ),
                        buttonOne: TextButton(
                          child: const Text('DISMISS'),
                          onPressed: () => settingsBloc.add(
                            SettingsUpdateOneSignalBannerDismiss(true),
                          ),
                        ),
                        buttonTwo: TextButton(
                          child: const Text('VIEW PRIVACY PAGE'),
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/privacy'),
                        ),
                        backgroundColor: Colors.deepOrange[900],
                      );
                    }
                  }
                  // Display alert banner about failure to connect to onesignal.com
                  if (oneSignalPrivacyBloc.state
                          is OneSignalPrivacyConsentSuccess &&
                      healthState is OneSignalHealthFailure) {
                    return _AlertBanner(
                      title: 'Unable to reach OneSignal',
                      message: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('• Notifications will not work.'),
                          const Text(
                              '• Registration with OneSignal will fail.'),
                        ],
                      ),
                      buttonOne: TextButton(
                        child: const Text('CHECK AGAIN'),
                        onPressed: () => context
                            .read<OneSignalHealthBloc>()
                            .add(OneSignalHealthCheck()),
                      ),
                    );
                  }
                  // Display alert banner about waiting to subscribe to OneSignal
                  if (oneSignalPrivacyBloc.state
                      is OneSignalPrivacyConsentSuccess) {
                    if (subscriptionState is OneSignalSubscriptionFailure) {
                      return _AlertBanner(
                        title: subscriptionState.title,
                        message: Text(
                          subscriptionState.message,
                        ),
                        buttonOne: TextButton(
                          child: const Text('LEARN MORE'),
                          onPressed: () async {
                            await launch(
                              'https://github.com/Tautulli/Tautulli-Remote/wiki/OneSignal#registering',
                            );
                          },
                        ),
                        backgroundColor: Colors.deepOrange[800],
                      );
                    }
                  }
                  // Return no banner if above criteria are not met
                  return Container(height: 0, width: 0);
                },
              );
            },
          );
        }
        return const SizedBox(height: 0, width: 0);
      },
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String title;
  final Widget message;
  final TextButton buttonOne;
  final TextButton buttonTwo;
  final Color backgroundColor;

  const _AlertBanner({
    Key key,
    this.title,
    this.message,
    this.buttonOne,
    this.buttonTwo,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      backgroundColor:
          backgroundColor != null ? backgroundColor : Colors.red[900],
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      forceActionsBelow: true,
      leading: const FaIcon(
        FontAwesomeIcons.exclamationCircle,
        color: TautulliColorPalette.not_white,
        size: 30,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null)
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          if (message != null) message,
        ],
      ),
      actions: <Widget>[
        if (buttonOne != null) buttonOne,
        if (buttonTwo != null) buttonTwo,
      ],
    );
  }
}
