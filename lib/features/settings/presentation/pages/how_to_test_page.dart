import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/notice_card.dart';
import '../../../../core/widgets/page_body.dart';

class HowToTestPage extends StatelessWidget {
  const HowToTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HowToTestView();
  }
}

class HowToTestView extends StatelessWidget {
  const HowToTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How To Test'),
      ),
      body: PageBody(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            NoticeCard(
              color: PlexColorPalette.curiousBlue.withAlpha(230),
              leading: const FaIcon(
                FontAwesomeIcons.flask,
                size: 28,
              ),
              title: 'Try Everything',
              content:
                  'Try every setting, feature, and function you can in Tautulli Remote.',
            ),
            const Gap(8),
            NoticeCard(
              color: Theme.of(context).colorScheme.error,
              leading: const FaIcon(
                FontAwesomeIcons.dumpsterFire,
                size: 28,
              ),
              title: 'Break Anything',
              content:
                  'Your goal is to intentionally break things. Try doing things in a strange order and exploit as many edge cases as you can.',
            ),
            const Gap(8),
            NoticeCard(
              color: Colors.brown[800],
              leading: const FaIcon(
                FontAwesomeIcons.poo,
                size: 28,
              ),
              title: 'Take A Dump',
              content:
                  "View your app's status and data using the Data Dump page under the Testing section of Settings.",
            ),
            const Gap(8),
            const NoticeCard(
              color: Color.fromRGBO(88, 101, 242, 0.9),
              leading: FaIcon(
                FontAwesomeIcons.discord,
                size: 28,
              ),
              title: 'Discuss the alpha',
              content:
                  'Visit the dedicated Discord channel #v3-alpha-discussion to chat about the new alpha.',
            ),
            const Gap(8),
            NoticeCard(
              color: PlexColorPalette.atlantis.withAlpha(200),
              leading: const FaIcon(
                FontAwesomeIcons.solidComment,
                size: 28,
              ),
              title: 'Let us know what you broke!',
              content:
                  "Submit bugs under Help & Support on the Settings page. Don't forget to mention it's for the alpha!",
            ),
            const Gap(8),
            NoticeCard(
              color: Theme.of(context).colorScheme.secondary.withAlpha(230),
              leading: const FaIcon(
                FontAwesomeIcons.solidLightbulb,
                size: 28,
              ),
              title: 'Got An Idea?',
              content:
                  "Submit feature requests under Help & Support on the Settings page. Don't forget to mention it's for the alpha!",
            ),
          ],
        ),
      ),
    );
  }
}
