import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/announcement_model.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final int lastReadAnnouncementId;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.lastReadAnnouncementId,
  });

  @override
  Widget build(BuildContext context) {
    return CardWithForcedTint(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: isNotBlank(announcement.actionUrl)
            ? () async {
                launchUrlString(
                  mode: LaunchMode.externalApplication,
                  announcement.actionUrl!,
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 400),
                          opacity: announcement.id > lastReadAnnouncementId ? 1 : 0,
                          child: FaIcon(
                            FontAwesomeIcons.solidCircle,
                            size: 10,
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (announcement.actionUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FaIcon(
                        FontAwesomeIcons.squareUpRight,
                        color: Theme.of(context).colorScheme.onSurface,
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
