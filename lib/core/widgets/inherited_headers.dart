// @dart=2.9

import 'package:flutter/material.dart';

class InheritedHeaders extends InheritedWidget {
  final Map<String, String> headerMap;

  InheritedHeaders({
    Key key,
    @required Widget child,
    @required this.headerMap,
  }) : super(key: key, child: child);

  static InheritedHeaders of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedHeaders>();
  }

  @override
  bool updateShouldNotify(InheritedHeaders oldWidget) {
    return true;
  }
}
