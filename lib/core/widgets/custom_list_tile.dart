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
          color: Theme.of(context).colorScheme.primary,
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
              style: inactive
                  ? TextStyle(
                      color: Theme.of(context).textTheme.titleSmall!.color,
                    )
                  : null,
            ),
            subtitle: subtitle != null
                ? Text(
                    sensitive && state is SettingsSuccess && state.appSettings.maskSensitiveInfo
                        ? LocaleKeys.hidden_message.tr()
                        : subtitle!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
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
