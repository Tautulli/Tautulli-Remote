import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class PlatformCustomIcons {
  static IconData more() {
    if (Platform.isIOS) {
      return Icons.more_horiz;
    }
    return Icons.more_vert;
  }
}
