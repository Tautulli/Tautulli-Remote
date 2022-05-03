import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/user_model.dart';

class UserIcon extends StatelessWidget {
  final UserModel user;

  const UserIcon({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
            child: user.userThumb != null && user.userThumb!.startsWith('http')
                ? FadeInImage.assetNetwork(
                    fadeInDuration: const Duration(milliseconds: 400),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    placeholder: 'assets/images/default_profile.png',
                    image: user.userThumb!,
                  )
                : Image.asset('assets/images/default_profile.png'),
          ),
          if (user.isActive != null && !user.isActive!)
            Positioned(
              bottom: -1,
              right: 0,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 3,
                    right: 5,
                    child: FaIcon(
                      FontAwesomeIcons.solidCircle,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 15,
                    ),
                  ),
                  FaIcon(
                    FontAwesomeIcons.exclamationTriangle,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
