import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'cupertino_card.dart';

class IosIconCard extends StatelessWidget {
  final Widget? background;
  final Widget icon;
  final Widget details;
  final Function()? onTap;

  const IosIconCard({
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
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(12),
        child: CupertinoCard(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              return Stack(
                children: [
                  if (!state.appSettings.disableImageBackgrounds && background != null)
                    Positioned.fill(
                      child: background!,
                    ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
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
                  ),
                  GestureDetector(
                    onTap: onTap,
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
