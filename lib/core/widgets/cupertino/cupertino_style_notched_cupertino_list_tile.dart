import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../base/sensitive_text.dart';

class CupertinoStyleNotchedCupertinoListTile extends StatelessWidget {
  final bool inactive;
  final String titleText;
  final String? subtitleText;
  final Widget? subtitleWidget;
  final Widget? leading;
  final Widget? additionalInfo;
  final Widget? trailing;
  final Function()? onTap;
  final Function()? onLongPress;
  final bool sensitive;
  final bool isDestructive;

  const CupertinoStyleNotchedCupertinoListTile({
    super.key,
    this.inactive = false,
    required this.titleText,
    this.subtitleText,
    this.subtitleWidget,
    this.leading,
    this.additionalInfo,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.sensitive = false,
    this.isDestructive = false,
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
            title: Text(
              titleText,
              style: TextStyle(
                color: inactive
                    ? CupertinoColors.inactiveGray
                    : isDestructive
                    ? CupertinoColors.destructiveRed
                    : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle:
                subtitleWidget ??
                (isNotBlank(subtitleText)
                    ? Text(
                        subtitleText!,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ).sensitive(enabled: sensitive)
                    : null),
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
