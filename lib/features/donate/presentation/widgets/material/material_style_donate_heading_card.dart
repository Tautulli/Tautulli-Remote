import 'package:flutter/material.dart';

import '../../../../../core/widgets/material/material_style_card.dart';
import '../base/donate_heading_card_content.dart';

class MaterialStyleDonateHeadingCard extends StatelessWidget {
  const MaterialStyleDonateHeadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialStyleCard(
      child: DonateHeadingCardContent(),
    );
  }
}
