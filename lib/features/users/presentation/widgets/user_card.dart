import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_table_model.dart';
import '../pages/user_details_page.dart';
import 'user_icon.dart';

Map<String, Color?> backgroundColorCache = {};

class UserCard extends StatefulWidget {
  final ServerModel server;
  final UserTableModel user;
  final Widget details;
  final bool fetchUser;

  const UserCard({
    super.key,
    required this.server,
    required this.user,
    required this.details,
    this.fetchUser = false,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late Future getColorFuture;
  late bool hasNetworkImage;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = widget.user.userThumb != null ? widget.user.userThumb!.startsWith('http') : false;
    getColorFuture = _getColor(widget.user.userThumb);
  }

  @override
  Widget build(BuildContext context) {
    final user = UserModel(
      userId: widget.user.userId,
      friendlyName: widget.user.friendlyName,
      userThumb: widget.user.userThumb,
      isActive: widget.user.isActive,
      lastSeen: widget.user.lastSeen,
    );

    return FutureBuilder(
      future: getColorFuture,
      builder: (context, snapshot) {
        // Load in cached color if it's cached to prevent the transition
        Color? color = backgroundColorCache['${widget.user.userId!}:${widget.user.friendlyName}'];

        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          backgroundColorCache['${widget.user.userId!}:${widget.user.friendlyName}'] = snapshot.data as Color;
          color = snapshot.data as Color;
        }

        return CardWithForcedTint(
          child: SizedBox(
            height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 100 * MediaQuery.of(context).textScaler.scale(1) : 100,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                return Stack(
                  children: [
                    if (!state.appSettings.disableImageBackgrounds)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: color != null ? _DarkenedBackground(color: color) : null,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          UserIcon(user: user),
                          const Gap(8),
                          Expanded(
                            child: widget.details,
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return UserDetailsPage(
                                  server: widget.server,
                                  user: user,
                                  backgroundColor: color,
                                  fetchUser: widget.fetchUser,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _DarkenedBackground extends StatelessWidget {
  final Color color;

  const _DarkenedBackground({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
      ],
    );
  }
}

Future<Color?> _getColor(String? url) async {
  if (url == null || !url.startsWith('http')) return null;

  final palette = await PaletteGenerator.fromImageProvider(
    CachedNetworkImageProvider(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
