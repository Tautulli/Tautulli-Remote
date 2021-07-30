import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';

class DoubleTapExit extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final Widget child;

  const DoubleTapExit({
    @required this.innerDrawerKey,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime currentBackPressTime;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadSuccess && state.doubleTapToExit) {
          return WillPopScope(
            onWillPop: () {
              if (innerDrawerKey.currentState.opened) {
                innerDrawerKey.currentState.close();
                return Future.value(false);
              }

              DateTime now = DateTime.now();

              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime) >
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
        return child;
      },
    );
  }
}
