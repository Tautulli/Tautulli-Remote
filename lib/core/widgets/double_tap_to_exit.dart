import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';

class DoubleTapToExit extends StatelessWidget {
  final Widget child;

  const DoubleTapToExit({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsState = context.read<SettingsBloc>().state as SettingsSuccess;
    DateTime? currentBackPressTime;

    if (!settingsState.appSettings.doubleTapToExit) return child;

    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();

        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: 'Press again to exit app');
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: child,
    );
  }
}
