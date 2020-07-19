import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/settings.dart';
import '../bloc/register_device_bloc.dart';
import 'server_setup_instructions.dart';

class ServerInfo extends StatelessWidget {
  final Settings settings;

  const ServerInfo({
    Key key,
    @required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BlocBuilder<RegisterDeviceBloc, RegisterDeviceState>(
            builder: (context, state) {
              //TODO: registerDeviceInProgress can get stuck if the qr scanner is backed out of
              // if (state is RegisterDeviceInProgress) {
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              // if both connectionAddress and deviceToken are not null and not empty strings display them
              return (settings.connectionAddress != null &&
                      settings.connectionAddress != '' &&
                      settings.deviceToken != null &&
                      settings.deviceToken != '')
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Connection Address'),
                        (settings.connectionAddress != null &&
                                settings.connectionAddress != '')
                            ? Text(
                                settings.connectionAddress,
                                style: TextStyle(color: Colors.grey[350]),
                              )
                            : Text(
                                'Required',
                                style: TextStyle(color: Colors.grey[350]),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Device Token'),
                        (settings.deviceToken != null &&
                                settings.deviceToken != '')
                            ? Text(
                                settings.deviceToken,
                                style: TextStyle(color: Colors.grey[350]),
                              )
                            : Text(
                                'Required',
                                style: TextStyle(color: Colors.grey[350]),
                              ),
                      ],
                    )
                  : ServerSetupInstructions();
            },
          ),
        ],
      ),
    );
  }
}
