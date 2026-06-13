import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../translations/locale_keys.g.dart';

class DoubleBackToExit extends StatefulWidget {
  final Widget child;
  final GlobalKey<InnerDrawerState>? innerDrawerKey;

  const DoubleBackToExit({
    super.key,
    required this.child,
    this.innerDrawerKey,
  });

  @override
  State<DoubleBackToExit> createState() => _DoubleBackToExitState();
}

class _DoubleBackToExitState extends State<DoubleBackToExit> {
  DateTime? _currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) return widget.child;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsSuccess && state.appSettings.doubleBackToExit) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              final bool shouldPop = _shouldPopRoute(
                currentBackPressTime: _currentBackPressTime,
                innerDrawerKey: widget.innerDrawerKey,
              );

              _currentBackPressTime = DateTime.now();

              if (shouldPop) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            },
            child: widget.child,
          );
        }
        return widget.child;
      },
    );
  }
}

bool _shouldPopRoute({
  required DateTime? currentBackPressTime,
  GlobalKey<InnerDrawerState>? innerDrawerKey,
}) {
  if (innerDrawerKey != null && innerDrawerKey.currentState!.opened) {
    innerDrawerKey.currentState!.close();
    return false;
  }

  DateTime now = DateTime.now();

  if (currentBackPressTime == null || now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_SHORT,
      msg: LocaleKeys.double_back_to_exit_toast_message.tr(),
    );
    return false;
  }

  return true;
}
