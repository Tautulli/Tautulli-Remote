import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';

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
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.inactive = false,
    this.sensitive = false,
  }) : super(key: key);

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
                  child: leading,
                ),
              ],
            ),
            title: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: inactive
                  ? TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                    )
                  : null,
            ),
            subtitle: subtitle != null
                ? Text(
                    sensitive &&
                            state is SettingsSuccess &&
                            state.appSettings.maskSensitiveInfo
                        ? 'HIDDEN'
                        : subtitle!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
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
