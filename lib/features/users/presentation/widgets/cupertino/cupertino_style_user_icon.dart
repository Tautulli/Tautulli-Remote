import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/user_icon_size.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';

class CupertinoStyleUserIcon extends StatelessWidget {
  final UserModel user;
  final UserIconSize size;

  const CupertinoStyleUserIcon({
    super.key,
    required this.user,
    this.size = UserIconSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size == UserIconSize.normal ? 60 : 80,
      width: size == UserIconSize.normal ? 60 : 80,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(50),
            ),
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                if (!state.appSettings.maskSensitiveInfo &&
                    user.userThumb != null &&
                    user.userThumb!.startsWith('http')) {
                  return CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 400),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    imageUrl: user.userThumb!,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/default_profile.png',
                    ),
                    errorWidget: (context, url, error) => Stack(
                      children: [
                        Image.asset('assets/images/default_profile.png'),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 4, left: 1),
                            child: Icon(
                              CupertinoIcons.exclamationmark,
                              color: ThemeHelper.cupertinoCardIconColor,
                              size: 24,
                            ),
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
              bottom: size == UserIconSize.normal ? -3 : -5,
              right: 0,
              child: Stack(
                children: [
                  Positioned(
                    bottom: size == UserIconSize.normal ? 3 : 6,
                    right: size == UserIconSize.normal ? 5 : 7,
                    child: Icon(
                      CupertinoIcons.circle_fill,
                      color: ThemeHelper.cupertinoCardIconColor,
                      size: size == UserIconSize.normal ? 16 : 21,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    color: CupertinoTheme.of(context).primaryColor,
                    size: size == UserIconSize.normal ? 26 : 36,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
