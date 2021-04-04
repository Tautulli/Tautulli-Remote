import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/users/domain/entities/user_table.dart';
import '../helpers/color_palette_helper.dart';

class UserIcon extends StatelessWidget {
  final UserTable user;
  final double size;
  final bool maskSensitiveInfo;

  const UserIcon({
    Key key,
    @required this.user,
    this.size,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        user.userThumb != null ? user.userThumb.startsWith('http') : false;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(50.0),
          ),
          child: Container(
            width: size ?? 60,
            height: size ?? 60,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: (!hasNetworkImage ||
                            (maskSensitiveInfo && size != null))
                        ? PlexColorPalette.shark
                        : Colors.transparent,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (hasNetworkImage && !maskSensitiveInfo)
                          ? NetworkImage(user.userThumb)
                          : const AssetImage(
                              'assets/images/default_profile.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    border: Border.all(
                      color: (hasNetworkImage && !maskSensitiveInfo)
                          ? Colors.transparent
                          : const Color.fromRGBO(69, 69, 69, 1),
                      width: 1,
                    ),
                  ),
                ),
              ],
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
              size: size != null ? size / 60 * 24 : 24,
            ),
          ),
      ],
    );
  }
}
