import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final int lastReadAnnouncementId;

  const AnnouncementCard({
    Key? key,
    required this.announcement,
    required this.lastReadAnnouncementId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onTap: isNotBlank(announcement.actionUrl)
            ? () async {
                launch(announcement.actionUrl!);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          announcement.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: announcement.id > lastReadAnnouncementId
                              ? FaIcon(
                                  FontAwesomeIcons.solidCircle,
                                  size: 10,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )
                              : const SizedBox(height: 10, width: 10),
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(announcement.body),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      '${LocaleKeys.published_title.tr()}: ${announcement.date}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: Theme.of(context).textTheme.subtitle2!.color,
                      ),
                    ),
                  ),
                  if (announcement.actionUrl != null)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: FaIcon(
                        FontAwesomeIcons.externalLinkSquareAlt,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
