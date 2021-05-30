import 'package:flutter/material.dart';

import '../../../../core/helpers/string_format_helper.dart';
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
        title: const Text('Are you sure you want to terminate this stream?'),
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
              decoration: const InputDecoration(
                  helperText: 'Terminate Message',
                  hintText: 'The server owner has ended the stream.'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              child: const Text('TERMINATE'),
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
            maskSensitiveInfo ? '*Hidden User*' : activity.friendlyName,
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
