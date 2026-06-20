import 'package:flutter/material.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/material/material_style_poster_card.dart';
import '../../../data/models/history_model.dart';
import '../../pages/material/material_style_history_details_page.dart';
import '../base/history_card_details.dart';
import '../base/history_details_title_row.dart';

class MaterialStyleHistoryCard extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool showUser;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const MaterialStyleHistoryCard({
    super.key,
    required this.server,
    required this.history,
    this.showUser = true,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStylePosterCard(
      mediaType: history.mediaType,
      uri: history.posterUri,
      details: HistoryCardDetails(
        history: history,
        iconColor: Theme.of(context).colorScheme.onSurface,
        titleRow: HistoryDetailsTitleRow(
          history: history,
          fontSize: 17,
        ),

        showUser: showUser,
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MaterialStyleHistoryDetailsPage(
            server: server,
            history: history,
            viewUserEnabled: viewUserEnabled,
            viewMediaEnabled: viewMediaEnabled,
          ),
        ),
      ),
    );
  }
}
