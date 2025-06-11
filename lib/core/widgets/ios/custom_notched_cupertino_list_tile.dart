import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../translations/locale_keys.g.dart';

class CustomNotchedCupertinoListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? additionalInfo;
  final Widget? trailing;
  final Function()? onTap;
  final Function()? onLongPress;
  final bool sensitive;

  const CustomNotchedCupertinoListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.additionalInfo,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.sensitive = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return GestureDetector(
          onLongPress: onLongPress,
          child: CupertinoListTile.notched(
            // Padding ensures proper layout inside ReorderableColumn, no change to the look with these values
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            title: title,
            subtitle: sensitive && state is SettingsSuccess && state.appSettings.maskSensitiveInfo ? const Text(LocaleKeys.hidden_message).tr() : subtitle,
            leading: leading,
            additionalInfo: additionalInfo,
            trailing: trailing,
            onTap: onTap,
          ),
        );
      },
    );
  }
}
