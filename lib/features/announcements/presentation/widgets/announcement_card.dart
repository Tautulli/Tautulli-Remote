// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';

class AnnouncementCard extends StatelessWidget {
  final int id;
  final String date;
  final String title;
  final String body;
  final String actionUrl;
  final int lastReadAnnouncementId;

  const AnnouncementCard({
    Key key,
    @required this.id,
    @required this.date,
    @required this.title,
    @required this.body,
    @required this.actionUrl,
    @required this.lastReadAnnouncementId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onTap: isNotEmpty(actionUrl)
            ? () async {
                await launch(actionUrl);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Text(
                          body,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isNotEmpty(actionUrl))
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: FaIcon(
                        FontAwesomeIcons.externalLinkAlt,
                        size: 20,
                        color: TautulliColorPalette.not_white,
                      ),
                    ),
                ],
              ),
              if (id > lastReadAnnouncementId)
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      height: 13,
                      width: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PlexColorPalette.gamboge.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
