import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/string_format_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../activity/domain/entities/activity.dart';

Future<int> showTerminateSessionDialog({
  @required BuildContext context,
  @required TextEditingController controller,
  @required ActivityItem activity,
  @required bool maskSensitiveInfo,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('${LocaleKeys.termination_dialog_title.tr()}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _TerminateSessionMediaInfo(
              activity: activity,
              maskSensitiveInfo: maskSensitiveInfo,
            ),
            TextFormField(
              controller: controller,
              maxLines: 2,
              decoration: InputDecoration(
                helperText: LocaleKeys.termination_terminate_message_label.tr(),
                hintText: '${LocaleKeys.termination_default_message.tr()}.',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              child: const Text(LocaleKeys.button_terminate).tr(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
          ),
        ],
      );
    },
  );
}

class _TerminateSessionMediaInfo extends StatelessWidget {
  final ActivityItem activity;
  final bool maskSensitiveInfo;

  const _TerminateSessionMediaInfo({
    Key key,
    @required this.activity,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String row1;
    String row2;
    String row3;

    switch (activity.mediaType) {
      case ('movie'):
        if (activity.title != null) {
          row1 = activity.title;
        }
        if (activity.year != null) {
          row2 = activity.year.toString();
        }
        break;
      case ('episode'):
        if (activity.grandparentTitle != null) {
          row1 = activity.grandparentTitle;
        }
        if (activity.title != null) {
          row2 = activity.title;
        }
        if (activity.parentMediaIndex != null && activity.mediaIndex != null) {
          row3 = 'S${activity.parentMediaIndex} • E${activity.mediaIndex}';
        } else if (activity.originallyAvailableAt != null &&
            activity.live == 1) {
          row3 = activity.originallyAvailableAt;
        }
        break;
      case ('track'):
        if (activity.title != null) {
          row1 = activity.title;
        }
        if (activity.grandparentTitle != null) {
          row2 = activity.grandparentTitle;
        }
        if (activity.parentTitle != null) {
          row3 = activity.parentTitle;
        }
        break;
      case ('clip'):
        if (activity.title != null) {
          row1 = activity.title;
        }
        if (activity.subType != null) {
          row2 = '(${StringFormatHelper.capitalize(activity.subType)})';
        }
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: <Widget>[
          Text(
            maskSensitiveInfo
                ? '*${LocaleKeys.masked_info_user.tr()}*'
                : activity.friendlyName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          if (row1 != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                row1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          if (row2 != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                row2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          if (row3 != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                row3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
