import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/card_with_forced_tint.dart';
import '../../../data/models/server_activity_model.dart';
import '../base/activity_info_card_bandwidth_info.dart';
import '../base/activity_info_card_streams_info.dart';

class MaterialStyleServerActivityInfoCard extends StatelessWidget {
  final ServerActivityModel serverActivity;

  const MaterialStyleServerActivityInfoCard({
    super.key,
    required this.serverActivity,
  });

  @override
  Widget build(BuildContext context) {
    return CardWithForcedTint(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.circleInfo,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface,
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
