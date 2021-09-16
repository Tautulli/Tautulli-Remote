// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';

class DeleteDialog extends StatelessWidget {
  final Widget titleWidget;

  const DeleteDialog({
    Key key,
    @required this.titleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleWidget,
      actions: <Widget>[
        TextButton(
          child: const Text(LocaleKeys.button_cancel).tr(),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text(LocaleKeys.button_confirm).tr(),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
