import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';

class DoubleTapToExit extends StatelessWidget {
  final Widget child;
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const DoubleTapToExit({
    Key? key,
    required this.child,
    required this.innerDrawerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsSuccess && state.appSettings.doubleTapToExit) {
          return WillPopScope(
            onWillPop: () {
              // If the inner drawer is open close it before trying to exit app
              if (innerDrawerKey.currentState!.opened) {
                innerDrawerKey.currentState!.close();
                return Future.value(false);
              }

              DateTime now = DateTime.now();

              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;
                Fluttertoast.showToast(
                  toastLength: Toast.LENGTH_SHORT,
                  msg: 'Press again to exit app',
                );
                return Future.value(false);
              }

              return Future.value(true);
            },
            child: child,
          );
        }
        return child;
      },
    );
  }
}
