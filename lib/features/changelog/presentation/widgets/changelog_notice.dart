import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChangelogNotice extends StatelessWidget {
  const ChangelogNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Welcome to Tautulli Remote 3!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Divider(),
              Text(
                'Tautulli Remote 3 is a complete rewrite that enhances what you can see (visuals and features) and what you can\'t (all the code).',
              ),
              Gap(6),
              Text(
                'This update took quite a bit of time and effort, with the first alpha build being released all the way back in February 2022. (Thank you alpha testers!)',
              ),
              Gap(6),
              Text(
                'As always Tautulli Remote remains free and open source. If you\'d like to support me so I can keep making this app for Android and iOS please consider donating.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
