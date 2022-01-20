import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Function()? onTap;
  final bool disabled;

  const SettingsListTile({
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          style: disabled
              ? TextStyle(
                  color: Theme.of(context).textTheme.subtitle2!.color,
                )
              : null,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: Theme.of(context).textTheme.subtitle2,
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
