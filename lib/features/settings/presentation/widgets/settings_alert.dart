import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';

class SettingsAlert extends StatelessWidget {
  const SettingsAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _OneSignalConnectionAlert(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _SubscriptionAlert(),
        ),
      ],
    );
  }
}

class _OneSignalConnectionAlert extends StatelessWidget {
  const _OneSignalConnectionAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = BlocProvider.of<OneSignalPrivacyBloc>(context);

    return BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
      builder: (context, state) {
        if (state is OneSignalHealthFailure &&
            oneSignalPrivacyBloc.state is OneSignalPrivacyConsentSuccess) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.red[900],
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FaIcon(
                      FontAwesomeIcons.exclamationCircle,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Unable to reach OneSignal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('• Notifications will not work.'),
                        Text('• Registration with OneSignal will fail.'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.redoAlt,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          BlocProvider.of<OneSignalHealthBloc>(context)
                              .add(OneSignalHealthCheck()),
                      tooltip: 'Recheck',
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(width: 0, height: 0);
      },
    );
  }
}

class _SubscriptionAlert extends StatelessWidget {
  const _SubscriptionAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OneSignalSubscriptionBloc, OneSignalSubscriptionState>(
      builder: (context, state) {
        if (state is OneSignalSubscriptionFailure) {
          // Wrap in gesture detector if alert is about missing consent
          if (state.consented == false) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/privacy'),
              child: _SubscriptionAlertContent(
                title: state.title,
                message: state.message,
                consented: state.consented,
              ),
            );
          }
          return _SubscriptionAlertContent(
            title: state.title,
            message: state.message,
          );
        }
        return Container(height: 0, width: 0);
      },
    );
  }
}

class _SubscriptionAlertContent extends StatelessWidget {
  final String title;
  final String message;
  final bool consented;

  const _SubscriptionAlertContent({
    Key key,
    @required this.title,
    @required this.message,
    this.consented,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: Colors.deepOrange[800],
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FaIcon(
                FontAwesomeIcons.exclamationCircle,
                color: Colors.white,
                size: 30,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (consented == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FaIcon(
                  FontAwesomeIcons.angleRight,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
