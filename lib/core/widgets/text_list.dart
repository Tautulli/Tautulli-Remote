// @dart=2.9

import 'package:flutter/material.dart';

class TextList extends StatelessWidget {
  final bool numberedList;
  final List<String> textItems;
  final double fontSize;
  final double leftPadding;
  final double spacing;

  const TextList({
    Key key,
    @required this.textItems,
    this.numberedList = false,
    this.fontSize = 14,
    this.leftPadding = 10,
    this.spacing = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [];

    for (var i = 0; i < textItems.length; i++) {
      widgetList.add(
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    numberedList ? '${i + 1}.' : '•',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      textItems[i],
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              if (i < textItems.length - 1) SizedBox(height: spacing),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgetList,
    );
  }
}
