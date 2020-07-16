import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String headingText;

  const SettingsHeader({
    Key key,
    @required this.headingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        // top: 20,
      ),
      child: Text(
        headingText,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
