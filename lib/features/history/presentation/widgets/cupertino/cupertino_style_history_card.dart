import 'package:flutter/cupertino.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster_card.dart';
import '../../../data/models/history_model.dart';
import '../../pages/cupertino/cupertino_style_history_details_page.dart';
import '../base/history_card_details.dart';
import '../base/history_details_title_row.dart';

class CupertinoStyleHistoryCard extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool showUser;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;
  final String? currentPageTitle;

  const CupertinoStyleHistoryCard({
    super.key,
    required this.server,
    required this.history,
    this.showUser = true,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
    this.currentPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePosterCard(
      mediaType: history.mediaType,
      uri: history.posterUri,
      details: HistoryCardDetails(
        history: history,
        iconColor: ThemeHelper.cupertinoCardIconColor(),
        titleRow: HistoryDetailsTitleRow(
          history: history,
          fontSize: 16,
        ),
        showUser: showUser,
      ),
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => CupertinoStyleHistoryDetailsPage(
            server: server,
            history: history,
            viewUserEnabled: viewUserEnabled,
            viewMediaEnabled: viewMediaEnabled,
            previousPageTitle: currentPageTitle,
          ),
        ),
      ),
    );
  }
}
