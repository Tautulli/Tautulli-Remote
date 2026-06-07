import 'package:flutter/cupertino.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/ios/ios_poster_card.dart';
import '../../../data/models/history_model.dart';
import '../../pages/cupertino/cupertino_style_history_details_page.dart';
import 'cupertino_style_history_card_details.dart';

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
    return IosPosterCard(
      mediaType: history.mediaType,
      uri: history.posterUri,
      details: CupertinoStyleHistoryCardDetails(
        history: history,
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
