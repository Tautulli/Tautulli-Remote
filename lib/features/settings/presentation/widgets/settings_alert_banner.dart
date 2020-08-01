import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';

class SettingsAlertBanner extends StatelessWidget {
  const SettingsAlertBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = BlocProvider.of<OneSignalPrivacyBloc>(context);

    return BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
      builder: (context, healthState) {
        return BlocBuilder<OneSignalSubscriptionBloc,
            OneSignalSubscriptionState>(
          builder: (context, subscriptionState) {
            // Display alert banner about consenting to privacy policy
            if (oneSignalPrivacyBloc.state is OneSignalPrivacyConsentFailure) {
              if (subscriptionState is OneSignalSubscriptionFailure) {
                return _AlertBanner(
                  title: subscriptionState.title,
                  message: Text(
                    subscriptionState.message,
                    style: TextStyle(color: TautulliColorPalette.not_white),
                  ),
                  buttonOne: FlatButton(
                    child: Text('VIEW PRIVACY PAGE'),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/privacy'),
                  ),
                  backgroundColor: Colors.deepOrange[900],
                );
              }
            }
            // Display alert banner about failure to connect to onesignal.com
            if (oneSignalPrivacyBloc.state is OneSignalPrivacyConsentSuccess &&
                healthState is OneSignalHealthFailure) {
              return _AlertBanner(
                title: 'Unable to reach OneSignal',
                message: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('• Notifications will not work.'),
                    Text('• Registration with OneSignal will fail.'),
                  ],
                ),
                buttonOne: FlatButton(
                  child: Text('Check again'),
                  onPressed: () => BlocProvider.of<OneSignalHealthBloc>(context)
                      .add(OneSignalHealthCheck()),
                ),
              );
            }
            // Display alert banner about waiting to subscribe to OneSignal
            if (oneSignalPrivacyBloc.state is OneSignalPrivacyConsentSuccess &&
                healthState is OneSignalHealthSuccess) {
              if (subscriptionState is OneSignalSubscriptionFailure) {
                return _AlertBanner(
                  title: subscriptionState.title,
                  message: Text(
                    subscriptionState.message,
                    style: TextStyle(color: TautulliColorPalette.not_white),
                  ),
                  buttonOne: FlatButton(
                    child: Text('LEARN MORE'),
                    //TODO: Link to wiki page
                    onPressed: () {},
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
}

class _AlertBanner extends StatelessWidget {
  final String title;
  final Widget message;
  final FlatButton buttonOne;
  final FlatButton buttonTwo;
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
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      forceActionsBelow: true,
      leading: FaIcon(
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
              style: TextStyle(
                color: TautulliColorPalette.not_white,
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
