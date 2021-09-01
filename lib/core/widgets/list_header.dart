// @dart=2.9

import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String headingText;

  const ListHeader({
    Key key,
    @required this.headingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
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
