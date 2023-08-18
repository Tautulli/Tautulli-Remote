import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../translations/locale_keys.g.dart';

class CustomListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Function()? onTap;
  final Function()? onLongPress;
  final bool inactive;
  final bool sensitive;

  const CustomListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
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
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  child: Center(
                    child: leading,
                  ),
                ),
              ],
            ),
            title: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: inactive ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    sensitive && state is SettingsSuccess && state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : subtitle!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: inactive ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: trailing,
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        );
      },
    );
  }
}
