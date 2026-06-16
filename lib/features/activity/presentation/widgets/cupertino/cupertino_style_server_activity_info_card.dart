import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../data/models/server_activity_model.dart';
import '../base/activity_info_card_bandwidth_info.dart';
import '../base/activity_info_card_streams_info.dart';

class CupertinoStyleServerActivityInfoCard extends StatelessWidget {
  final ServerActivityModel serverActivity;

  const CupertinoStyleServerActivityInfoCard({
    super.key,
    required this.serverActivity,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleCard(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.info_circle_fill,
              color: ThemeHelper.cupertinoCardIconColor,
            ),
            const Gap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActivityInfoCardStreamsInfo(serverActivity: serverActivity),
                  ActivityInfoCardBandwidthInfo(serverActivity: serverActivity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
