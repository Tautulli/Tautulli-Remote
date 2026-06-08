import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../base/donate_heading_card_content.dart';

class CupertinoStyleDonateHeadingCard extends StatelessWidget {
  const CupertinoStyleDonateHeadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoStyleCard(
      child: DonateHeadingCardContent(),
    );
  }
}
