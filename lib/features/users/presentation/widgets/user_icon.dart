import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class UserIcon extends StatelessWidget {
  final int isActive;
  final bool hasNetworkImage;
  final AsyncSnapshot<dynamic> snapshot;

  const UserIcon({
    Key key,
    @required this.isActive,
    @required this.hasNetworkImage,
    @required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (hasNetworkImage && snapshot.data != null)
                  ? snapshot.data['image']
                  : AssetImage('assets/images/default_profile.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            border: Border.all(
              color: (hasNetworkImage && snapshot.data != null)
                  ? Colors.transparent
                  : Color.fromRGBO(69, 69, 69, 1),
              width: 1,
            ),
          ),
        ),
        if (isActive == 0)
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
