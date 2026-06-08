import 'package:flutter/material.dart';

import '../../../../../core/widgets/card_with_forced_tint.dart';
import '../base/donate_heading_card_content.dart';

class MaterialStyleDonateHeadingCard extends StatelessWidget {
  const MaterialStyleDonateHeadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardWithForcedTint(
      child: DonateHeadingCardContent(),
    );
  }
}
