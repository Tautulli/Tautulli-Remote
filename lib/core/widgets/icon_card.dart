import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import 'card_with_forced_tint.dart';

class IconCard extends StatelessWidget {
  final Widget? background;
  final Widget icon;
  final Widget details;
  final Function()? onTap;

  const IconCard({
    super.key,
    this.background,
    required this.icon,
    required this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 100 * MediaQuery.of(context).textScaler.scale(1) : 100,
      child: CardWithForcedTint(
        color: background != null ? Colors.transparent : null,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return Stack(
              children: [
                if (!state.appSettings.disableImageBackgrounds && background != null)
                  Positioned.fill(
                    child: background!,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: icon,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: details,
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
