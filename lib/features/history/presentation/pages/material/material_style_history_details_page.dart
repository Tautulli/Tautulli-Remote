import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/material/material_style_poster_details_page.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/material/material_style_media_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/pages/material/material_style_user_details_page.dart';
import '../../../data/models/history_model.dart';
import '../../widgets/base/history_details_page_details.dart';

class MaterialStyleHistoryDetailsPage extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const MaterialStyleHistoryDetailsPage({
    super.key,
    required this.server,
    required this.history,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleHistoryDetailsView(
      server: server,
      history: history,
      viewUserEnabled: viewUserEnabled,
      viewMediaEnabled: viewMediaEnabled,
    );
  }
}

class MaterialStyleHistoryDetailsView extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const MaterialStyleHistoryDetailsView({
    super.key,
    required this.server,
    required this.history,
    required this.viewUserEnabled,
    required this.viewMediaEnabled,
  });

  String _getItemTitle() {
    switch (history.mediaType) {
      case (MediaType.episode):
        return history.grandparentTitle ?? '';
      default:
        return history.title ?? '';
    }
  }

  String? _getItemSubtitle() {
    switch (history.mediaType) {
      case (MediaType.episode):
        return history.title;
      case (MediaType.track):
        return history.grandparentTitle;
      default:
        return null;
    }
  }

  String? _getItemDetail(String? dateFormat) {
    final mediaType = history.mediaType;

    if (mediaType == MediaType.movie && history.year != null) {
      return history.year.toString();
    }

    if (mediaType == MediaType.episode &&
        history.live == true &&
        history.mediaIndex == null &&
        history.date != null) {
      return TimeHelper.cleanDateTime(history.date!, dateOnly: true, dateFormat: dateFormat);
    }

    if (mediaType == MediaType.episode && (history.parentMediaIndex != null || history.mediaIndex != null)) {
      return '${history.parentMediaIndex != null ? "S${history.parentMediaIndex}" : ""}${history.parentMediaIndex != null && history.mediaIndex != null ? " • " : ""}${history.mediaIndex != null ? "E${history.mediaIndex}" : ""}';
    }

    if (mediaType == MediaType.track) {
      return history.parentTitle;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final itemTitle = _getItemTitle();
    final itemSubtitle = _getItemSubtitle();

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        final textColor = Theme.of(context).colorScheme.onSurface;

        return MaterialStylePosterDetailsPage(
          itemTitle: itemTitle,
          itemSubtitle: itemSubtitle,
          itemDetail: _getItemDetail(settingsState.appSettings.activeServer.dateFormat),
          posterUri: history.posterUri,
          mediaType: history.mediaType,
          appBarActions: _buildAppBarActions(context),
          body: HistoryDetailsPageDetails(
            server: server,
            history: history,
            titleColor: Theme.of(context).colorScheme.onSurfaceVariant,
            loadingIndicator: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 130,
                child: LinearProgressIndicator(
                  color: textColor,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: FaIcon(
          FontAwesomeIcons.solidUser,
          size: 20,
          color: viewUserEnabled ? Theme.of(context).colorScheme.onSurface : null,
        ),
        onPressed: viewUserEnabled
            ? () {
                final user = UserModel(
                  friendlyName: history.friendlyName,
                  userId: history.userId,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MaterialStyleUserDetailsPage(
                      server: server,
                      user: user,
                      fetchUser: true,
                    ),
                  ),
                );
              }
            : null,
      ),
      IconButton(
        icon: FaIcon(
          FontAwesomeIcons.circleInfo,
          size: 20,
          color: viewMediaEnabled ? Theme.of(context).colorScheme.onSurface : null,
        ),
        onPressed: viewMediaEnabled
            ? () {
                final media = MediaModel(
                  grandparentRatingKey: history.grandparentRatingKey,
                  grandparentTitle: history.grandparentTitle,
                  imageUri: history.posterUri,
                  live: history.live,
                  mediaIndex: history.mediaIndex,
                  mediaType: history.mediaType,
                  parentMediaIndex: history.parentMediaIndex,
                  parentRatingKey: history.parentRatingKey,
                  parentTitle: history.parentTitle,
                  ratingKey: history.ratingKey,
                  title: history.title,
                  year: history.year,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MaterialStyleMediaPage(
                      server: server,
                      media: media,
                    ),
                  ),
                );
              }
            : null,
      ),
    ];
  }
}
