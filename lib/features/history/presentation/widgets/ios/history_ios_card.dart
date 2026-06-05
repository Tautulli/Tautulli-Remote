import 'package:flutter/cupertino.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/ios/ios_poster_card.dart';
import '../../../data/models/history_model.dart';
import '../../pages/ios/history_details_ios_page.dart';
import 'history_ios_card_details.dart';

class HistoryIosCard extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool showUser;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;
  final String? currentPageTitle;

  const HistoryIosCard({
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
      details: HistoryIosCardDetails(history: history),
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => HistoryDetailsIosPage(
            server: server,
            history: history,
            previousPageTitle: currentPageTitle,
          ),
        ),
      ),
    );
  }
}
