import 'package:flutter/material.dart';

class ServerHeader extends StatelessWidget {
  final String serverName;

  const ServerHeader({
    Key key,
    @required this.serverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        top: 4,
        bottom: 4,
      ),
      child: Text(
        serverName,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}