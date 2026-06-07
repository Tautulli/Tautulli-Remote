import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'cupertino_style_card.dart';

class CupertinoStyleIconCard extends StatelessWidget {
  final Widget? background;
  final Widget icon;
  final Widget details;
  final Function()? onTap;

  const CupertinoStyleIconCard({
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
      child: GestureDetector(
        onTap: onTap,
        child: CupertinoStyleCard(
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
                            height: 55,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
