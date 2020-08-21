import 'package:flutter/material.dart';

import '../../../../core/helpers/time_format_helper.dart';
import '../../domain/entities/user_table.dart';

class UsersDetails extends StatelessWidget {
  final UserTable user;

  const UsersDetails({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          user.friendlyName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18),
        ),
        user.lastPlayed != null
            ? Text(
                '${user.lastPlayed}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              )
            : Text(
                '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
        user.lastSeen != null
            ? Text(
                '${TimeFormatHelper.timeAgo(user.lastSeen)}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                ),
              )
            : Text(
                'never',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
      ],
    );
  }
}
