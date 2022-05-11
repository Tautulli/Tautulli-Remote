import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';

class UserIcon extends StatelessWidget {
  final UserModel user;

  const UserIcon({
    super.key,
    required this.user,
  });

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
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                if (!state.appSettings.maskSensitiveInfo &&
                    user.userThumb != null &&
                    user.userThumb!.startsWith('http')) {
                  return FadeInImage.assetNetwork(
                    fadeInDuration: const Duration(milliseconds: 400),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    placeholder: 'assets/images/default_profile.png',
                    image: user.userThumb!,
                    imageErrorBuilder: (context, object, stackTrace) => Stack(
                      children: [
                        Image.asset('assets/images/default_profile.png'),
                        Positioned.fill(
                          child: FaIcon(
                            FontAwesomeIcons.exclamation,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Image.asset('assets/images/default_profile.png');
              },
            ),
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
                    FontAwesomeIcons.triangleExclamation,
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
