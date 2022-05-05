import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import 'settings_not_loaded.dart';

class PageBody extends StatelessWidget {
  final Widget child;
  final bool loading;

  const PageBody({
    Key? key,
    required this.child,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsSuccess) {
            return Stack(
              children: [
                child,
                if (loading) const LinearProgressIndicator(),
              ],
            );
          }

          return const SettingsNotLoaded();
        },
      ),
    );
  }
}
