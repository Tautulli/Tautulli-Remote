import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/user_table_model.dart';
import '../../pages/cupertino/cupertino_style_user_details_page.dart';
import 'cupertino_style_user_icon.dart';

Map<String, Color?> backgroundColorCache = {};

class CupertinoStyleUserCard extends StatefulWidget {
  final ServerModel server;
  final UserTableModel user;
  final Widget details;
  final bool fetchUser;
  final String? currentPageTitle;

  const CupertinoStyleUserCard({
    super.key,
    required this.server,
    required this.user,
    required this.details,
    this.fetchUser = false,
    this.currentPageTitle,
  });

  @override
  State<CupertinoStyleUserCard> createState() => _CupertinoStyleUserCardState();
}

class _CupertinoStyleUserCardState extends State<CupertinoStyleUserCard> {
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

        return CupertinoStyleCard(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => CupertinoStyleUserDetailsPage(
                  server: widget.server,
                  user: user,
                  backgroundColor: color,
                  fetchUser: widget.fetchUser,
                  previousPageTitle: widget.currentPageTitle,
                ),
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).textScaler.scale(1) > 1
                  ? 100 * MediaQuery.of(context).textScaler.scale(1)
                  : 100,
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  state as SettingsSuccess;

                  return Stack(
                    children: [
                      if (!state.appSettings.disableImageBackgrounds)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Container(
                            color: color != null
                                ? Color.alphaBlend(
                                    CupertinoColors.black.withValues(alpha: 0.6),
                                    color,
                                  )
                                : null,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CupertinoStyleUserIcon(user: user),
                            const Gap(8),
                            Expanded(
                              child: widget.details,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<Color?> _getColor(String? url) async {
  if (url == null || !url.startsWith('http')) return null;

  final palette = await PaletteGeneratorMaster.fromImageProvider(
    CachedNetworkImageProvider(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
