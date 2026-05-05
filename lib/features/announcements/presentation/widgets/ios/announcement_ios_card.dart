import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/ios/cupertino_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/announcement_model.dart';

class AnnouncementIosCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final int lastReadAnnouncementId;

  const AnnouncementIosCard({
    super.key,
    required this.announcement,
    required this.lastReadAnnouncementId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      child: GestureDetector(
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
                          child: Icon(
                            CupertinoIcons.circle_fill,
                            size: 10,
                            color: CupertinoTheme.of(context).primaryColor,
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
                      child: Icon(
                        CupertinoIcons.arrow_up_right_square_fill,
                        color: ThemeHelper.cupertinoCardIconColor(),
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
