import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../data/models/user_model.dart';
import 'user_details.dart';
import 'user_icon.dart';

Map<int, Color?> backgroundColorCache = {};

class UserCard extends StatefulWidget {
  final UserModel user;

  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late Future getColorFuture;
  late bool hasNetworkImage;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = widget.user.userThumb != null
        ? widget.user.userThumb!.startsWith('http')
        : false;
    getColorFuture = _getColor(widget.user.userThumb);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getColorFuture,
      builder: (context, snapshot) {
        // Load in cached color if it's cached to prevent the transition
        Color? color = backgroundColorCache[widget.user.userId!];

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          backgroundColorCache[widget.user.userId!] = snapshot.data as Color;
          color = snapshot.data as Color;
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 100,
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: color != null
                      ? _DarkenedBackground(color: color)
                      : Container(
                          color: Theme.of(context).cardColor,
                        ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        UserIcon(user: widget.user),
                        const Gap(8),
                        Expanded(
                          child: UserDetails(user: widget.user),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
    Key? key,
    required this.color,
  }) : super(key: key);

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
    NetworkImage(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
