import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../domain/entities/user.dart';
import 'user_details.dart';
import 'user_icon.dart';

class UsersCard extends StatefulWidget {
  final User user;

  const UsersCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _UsersCardState createState() => _UsersCardState();
}

class _UsersCardState extends State<UsersCard> {
  Future getColorFuture;
  bool hasNetworkImage;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = widget.user.userThumb.startsWith('http');
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
        return Card(
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
                        UserIcon(
                          isActive: widget.user.isActive,
                          hasNetworkImage: hasNetworkImage,
                          snapshot: snapshot,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: UsersDetails(user: widget.user),
                          ),
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
