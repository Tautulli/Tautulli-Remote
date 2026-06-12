import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../base/sensitive_text.dart';

class MaterialStyleRadioListTile<T> extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final T value;
  final bool inactive;
  final bool sensitive;

  const MaterialStyleRadioListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.value,
    this.inactive = false,
    this.sensitive = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Material(
          color: ElevationOverlay.applySurfaceTint(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceTint,
            1,
          ),
          child: RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            value: value,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 40,
                  ),
                  child: Center(
                    child: leading,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: inactive
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ).sensitive(enabled: sensitive),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
