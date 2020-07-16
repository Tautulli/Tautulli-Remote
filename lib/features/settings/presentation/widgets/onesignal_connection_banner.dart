import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';

class OneSignalConnectionBanner extends StatelessWidget {
  const OneSignalConnectionBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Unable to reach onesignal.com',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Notifications will not work.'),
              Text('• Registration with OneSignal will fail.'),
            ],
          ),
          GestureDetector(
            onTap: () => BlocProvider.of<OneSignalHealthBloc>(context)
                .add(OneSignalHealthCheck()),
            child: Column(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.redoAlt,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Text('Recheck'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
