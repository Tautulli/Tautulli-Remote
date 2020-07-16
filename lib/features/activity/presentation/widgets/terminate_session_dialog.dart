import 'package:flutter/material.dart';

Future terminateSessionDialog({
  @required BuildContext context,
  @required TextEditingController messageController,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Terminate Stream?',
      ),
      content: Container(
        // height: 116,
        child: TextField(
          controller: messageController,
          decoration: InputDecoration(
            // labelText: 'Terminate Message',
            hintText: 'The server owner has ended the stream.'
          ),
          maxLines: 2,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'No',
          ),
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
        ),
        FlatButton(
          child: Text(
            'Yes',
          ),
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
        ),
      ],
    ),
  );
}
