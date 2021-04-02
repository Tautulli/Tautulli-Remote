import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../features/users/presentation/pages/user_details_page.dart';

import '../../features/users/domain/entities/user_table.dart';
import '../helpers/color_palette_helper.dart';
import 'user_icon.dart';

class UserCard extends StatefulWidget {
  final UserTable user;
  final Widget details;
  final bool maskSensitiveInfo;

  const UserCard({
    Key key,
    this.user,
    this.details,
    this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Future getColorFuture;
  bool hasNetworkImage;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = widget.user.userThumb != null
        ? widget.user.userThumb.startsWith('http')
        : false;
    getColorFuture = _getColor(hasNetworkImage, widget.user.userThumb);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getColorFuture,
      builder: (context, snapshot) {
        bool hasCustomColor =
            snapshot.connectionState == ConnectionState.done &&
                snapshot.data['color'] != null;
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return UserDetailsPage(
                    user: widget.user,
                    backgroundColor:
                        hasCustomColor ? snapshot.data['color'] : null,
                    heroTag: ValueKey(widget.user.userId),
                    forceGetUser: widget.user.lastSeen == null,
                  );
                },
              ),
            );
          },
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  // Card color
                  Container(
                    height: 100,
                    color: hasCustomColor ? snapshot.data['color'] : null,
                  ),
                  // Darken card if it has a custom color
                  if (hasNetworkImage && hasCustomColor)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Hero(
                            tag: ValueKey(widget.user.userId),
                            child: UserIcon(
                              user: widget.user,
                              maskSensitiveInfo: widget.maskSensitiveInfo,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: widget.details,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<Map<String, dynamic>> _getColor(bool hasUrl, String url) async {
  if (hasUrl) {
    NetworkImage userProfileImage = NetworkImage(url);
    final palette = await PaletteGenerator.fromImageProvider(
      NetworkImage(url),
      maximumColorCount: 1,
    );
    return {
      'image': userProfileImage,
      'color': palette.colors.isNotEmpty ? palette.dominantColor.color : null,
    };
  }
  return {
    'image': null,
    'color': PlexColorPalette.shark,
  };
}
