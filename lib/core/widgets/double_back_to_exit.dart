import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../translations/locale_keys.g.dart';

class DoubleBackToExit extends StatelessWidget {
  final Widget child;
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const DoubleBackToExit({
    Key? key,
    required this.child,
    required this.innerDrawerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsSuccess && state.appSettings.doubleBackToExit) {
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
                  msg: LocaleKeys.double_back_to_exit_toast_message.tr(),
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