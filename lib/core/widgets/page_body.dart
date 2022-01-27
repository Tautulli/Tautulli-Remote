import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import 'settings_not_loaded.dart';

class PageBody extends StatelessWidget {
  final Widget child;

  const PageBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsSuccess) return child;

          return const SettingsNotLoaded();
        },
      ),
    );
  }
}
