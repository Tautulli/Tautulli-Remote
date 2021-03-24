import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/users/domain/entities/user_table.dart';
import '../helpers/color_palette_helper.dart';

class UserIcon extends StatelessWidget {
  final UserTable user;
  final bool maskSensitiveInfo;

  const UserIcon({
    Key key,
    @required this.user,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        user.userThumb != null ? user.userThumb.startsWith('http') : false;

    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (hasNetworkImage &&
                      user.userThumb != null &&
                      !maskSensitiveInfo)
                  ? NetworkImage(user.userThumb)
                  : AssetImage('assets/images/default_profile.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            border: Border.all(
              color: (hasNetworkImage &&
                      user.userThumb != null &&
                      !maskSensitiveInfo)
                  ? Colors.transparent
                  : Color.fromRGBO(69, 69, 69, 1),
              width: 1,
            ),
          ),
        ),
        if (user.isActive == 0)
          Positioned(
            bottom: 0,
            right: 0,
            child: FaIcon(
              FontAwesomeIcons.exclamationTriangle,
              color: TautulliColorPalette.amber,
            ),
          ),
      ],
    );
  }
}
