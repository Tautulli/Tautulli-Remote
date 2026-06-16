import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/overrides/cupertino/nav_bar_override.dart' as nav;
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster.dart';
import '../../../../../core/widgets/cupertino/dialogs/cupertino_style_failure_alert_dialog.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/cupertino/cupertino_style_media_page.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/pages/cupertino/cupertino_style_user_details_page.dart';
import '../../../data/models/activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../bloc/terminate_stream_bloc.dart';
import '../../widgets/base/progress_bar.dart';
import '../../widgets/cupertino/bottom_sheets/cupertino_style_terminate_stream_bottom_sheet.dart';
import '../../widgets/cupertino/cupertino_style_activity_details_page_details.dart';
import '../../widgets/cupertino/cupertino_style_activity_details_page_info.dart';
import '../../widgets/cupertino/cupertino_style_progress_percent.dart';
import '../../widgets/cupertino/cupertino_style_time_total.dart';

class CupertinoStyleActivityDetailsPage extends StatelessWidget {
  final ServerModel server;
  final ActivityModel activity;
  final String? previousPageTitle;

  const CupertinoStyleActivityDetailsPage({
    super.key,
    required this.server,
    required this.activity,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TerminateStreamBloc>(param1: context.read<SettingsBloc>()),
      child: CupertinoStyleActivityDetailsView(
        server: server,
        activity: activity,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class CupertinoStyleActivityDetailsView extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;
  final String? previousPageTitle;

  const CupertinoStyleActivityDetailsView({
    super.key,
    required this.server,
    required this.activity,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleActivityDetailsView> createState() => _CupertinoStyleActivityDetailsViewState();
}

class _CupertinoStyleActivityDetailsViewState extends State<CupertinoStyleActivityDetailsView> {
  late ActivityModel activity;
  late Uri? posterUri;

  @override
  void initState() {
    super.initState();

    activity = widget.activity;

    switch (activity.mediaType) {
      case (MediaType.episode):
        posterUri = activity.grandparentImageUri;
        break;
      default:
        posterUri = activity.imageUri;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topAreaHeight = MediaQuery.paddingOf(context).top + kMinInteractiveDimensionCupertino + 10;

    return MultiBlocListener(
      listeners: [
        BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            // Update activity to most recent data and if the item no longer exists close the bottom sheet
            try {
              final activityList = state.serverActivityList
                  .firstWhere((server) => server.tautulliId == widget.server.tautulliId)
                  .activityList;
              final item = activityList.firstWhere(
                (item) => item.sessionId == activity.sessionId && item.sessionKey == activity.sessionKey,
              );

              setState(() {
                activity = item;
              });
            } catch (_) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<TerminateStreamBloc, TerminateStreamState>(
          listener: (context, state) {
            if (state is TerminateStreamSuccess) {
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_LONG,
                msg: LocaleKeys.termination_request_sent_message.tr(),
              );
            }

            if (state is TerminateStreamFailure) {
              showCupertinoStyleFailureAlertDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
        ),
      ],
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.transparent,
        navigationBar: nav.CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(end: 16),
          enableBackgroundFilterBlur: false,
          backgroundColor: CupertinoColors.transparent,
          leading: CupertinoNavigationBarBackButton(
            previousPageTitle: widget.previousPageTitle,
            color: ThemeHelper.cupertinoNavigationBarItemColor,
            onPressed: () => Navigator.pop(context),
          ),
          trailing: _navBarActions(),
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
                          child: (!settingsState.appSettings.disableImageBackgrounds && activity.imageUri != null)
                              ? ImageGradientBackground(
                                  imageUri: posterUri,
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
                              child: CupertinoStyleActivityDetailsPageInfo(activity: activity),
                            ),
                            //* Details
                            ProgressBar(
                              activity: activity,
                              backgroundColor: CupertinoColors.black.withValues(alpha: 0.26),
                              transcodeColor: ThemeHelper.cupertinoCardIconColor,
                              progressColor: CupertinoTheme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                              child: Row(
                                children: [
                                  if (activity.live != true &&
                                      activity.duration != null &&
                                      activity.viewOffset != null &&
                                      activity.duration != null)
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (activity.progressPercent != null)
                                            CupertinoStyleProgressPercent(progressPercent: activity.progressPercent!),
                                          CupertinoStyleTimeTotal(
                                            viewOffset: activity.viewOffset!,
                                            duration: activity.duration!,
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (activity.live == true)
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('${activity.channelCallSign}'),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: CupertinoStyleActivityDetailsPageDetails(
                                server: widget.server,
                                activity: activity,
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
                      mediaType: activity.mediaType,
                      uri: posterUri,
                      activityState: activity.state,
                      opaqueBackground: true,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _navBarActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: const Icon(
            CupertinoIcons.person_fill,
            color: ThemeHelper.cupertinoNavigationBarItemColor,
          ),
          onPressed: () {
            final user = UserModel(
              friendlyName: activity.friendlyName,
              userId: activity.userId,
            );

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => CupertinoStyleUserDetailsPage(
                  server: widget.server,
                  user: user,
                  fetchUser: true,
                ),
              ),
            );
          },
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          child: const Icon(
            CupertinoIcons.info_circle_fill,
            color: ThemeHelper.cupertinoNavigationBarItemColor,
          ),
          onPressed: () {
            final media = MediaModel(
              grandparentRatingKey: activity.grandparentRatingKey,
              grandparentTitle: activity.grandparentTitle,
              imageUri: posterUri,
              live: activity.live,
              mediaIndex: activity.mediaIndex,
              mediaType: activity.mediaType,
              parentMediaIndex: activity.parentMediaIndex,
              parentRatingKey: activity.parentRatingKey,
              parentTitle: activity.parentTitle,
              ratingKey: activity.ratingKey,
              title: activity.title,
              year: activity.year,
            );

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => CupertinoStyleMediaPage(
                  server: widget.server,
                  media: media,
                ),
              ),
            );
          },
        ),
        if (widget.server.plexPass == true && activity.mediaType != MediaType.photo)
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: CupertinoColors.destructiveRed,
            ),
            onPressed: () async {
              final TextEditingController controller = TextEditingController();

              final bool? confirm = await showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoStyleTerminateStreamBottomSheet(
                  activity: activity,
                  controller: controller,
                ),
              );

              if (confirm == true) {
                context.read<TerminateStreamBloc>().add(
                  TerminateStreamStarted(
                    server: widget.server,
                    sessionId: activity.sessionId,
                    sessionKey: activity.sessionKey,
                    message: controller.text,
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
