import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/override/cupertino/nav_bar_override.dart' as nav;
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/cupertino/cupertino_style_media_page.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/pages/cupertino/cupertino_style_user_details_page.dart';
import '../../../data/models/history_model.dart';
import '../../widgets/base/history_details_info.dart';
import '../../widgets/cupertino/cupertino_style_history_details_page_details.dart';

class CupertinoStyleHistoryDetailsPage extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;
  final String? previousPageTitle;

  const CupertinoStyleHistoryDetailsPage({
    super.key,
    required this.server,
    required this.history,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleHistoryDetailsView(
      server: server,
      history: history,
      viewUserEnabled: viewUserEnabled,
      viewMediaEnabled: viewMediaEnabled,
      previousPageTitle: previousPageTitle,
    );
  }
}

class CupertinoStyleHistoryDetailsView extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;
  final String? previousPageTitle;

  const CupertinoStyleHistoryDetailsView({
    super.key,
    required this.server,
    required this.history,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    final double topAreaHeight = MediaQuery.paddingOf(context).top + kMinInteractiveDimensionCupertino + 10;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.transparent,
      navigationBar: nav.CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16),
        enableBackgroundFilterBlur: false,
        backgroundColor: CupertinoColors.transparent,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: previousPageTitle,
          color: ThemeHelper.cupertinoNavigationBarItemColor(),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: _navBarActions(context),
      ),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          settingsState as SettingsSuccess;

          return Stack(
            children: [
              Column(
                children: [
                  //* Background
                  SizedBox(
                    height: topAreaHeight + 60,
                    width: double.infinity,
                    child: ClipRect(
                      child: ColoredBox(
                        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                        child: DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            color: CupertinoColors.black.withValues(alpha: 0.2),
                          ),
                          child: !settingsState.appSettings.disableImageBackgrounds
                              ? ImageGradientBackground(
                                  imageUri: history.posterUri,
                                  httpHeaders: {
                                    for (CustomHeaderModel headerModel
                                        in settingsState.appSettings.activeServer.customHeaders)
                                      headerModel.key: headerModel.value,
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 97,
                            padding: const EdgeInsets.only(left: 8 + 100 + 8, right: 8, top: 4),
                            //* Item Info
                            child: HistoryDetailsInfo(
                              history: history,
                              fontSize: 20,
                            ),
                          ),
                          //* Details
                          Expanded(
                            child: CupertinoStyleHistoryDetailsPageDetails(
                              history: history,
                              server: server,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //* Poster
              Positioned(
                left: 8,
                top: topAreaHeight,
                child: SizedBox(
                  height: 150,
                  child: CupertinoStylePoster(
                    mediaType: history.mediaType,
                    uri: history.posterUri,
                    opaqueBackground: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _navBarActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          onPressed: viewUserEnabled
              ? () {
                  final user = UserModel(
                    friendlyName: history.friendlyName,
                    userId: history.userId,
                  );

                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleUserDetailsPage(
                        server: server,
                        user: user,
                        fetchUser: true,
                      ),
                    ),
                  );
                }
              : null,
          child: Icon(
            CupertinoIcons.person_fill,
            color: viewUserEnabled ? ThemeHelper.cupertinoNavigationBarItemColor() : null,
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8),
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
                    CupertinoPageRoute(
                      builder: (context) => CupertinoStyleMediaPage(
                        server: server,
                        media: media,
                      ),
                    ),
                  );
                }
              : null,
          child: Icon(
            CupertinoIcons.info_circle_fill,
            color: viewMediaEnabled ? ThemeHelper.cupertinoNavigationBarItemColor() : null,
          ),
        ),
      ],
    );
  }
}
