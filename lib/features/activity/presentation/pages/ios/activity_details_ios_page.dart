import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/custom_cupertino_nav_bar.dart' as nav;
import '../../../../../core/widgets/ios/failure_cupertino_alert_dialog.dart';
import '../../../../../core/widgets/ios/ios_poster.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/ios/media_ios_page.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/pages/ios/user_details_ios_page.dart';
import '../../../data/models/activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../bloc/terminate_stream_bloc.dart';
import '../../widgets/ios/activity_details_ios_page_details.dart';
import '../../widgets/ios/activity_details_ios_page_info.dart';
import '../../widgets/ios/ios_progress_bar.dart';
import '../../widgets/ios/progress_ios_percent.dart';
import '../../widgets/ios/terminate_stream_ios_bottom_sheet.dart';
import '../../widgets/ios/time_ios_total.dart';

class ActivityDetailsIosPage extends StatelessWidget {
  final ServerModel server;
  final ActivityModel activity;
  final String? previousPageTitle;

  const ActivityDetailsIosPage({
    super.key,
    required this.server,
    required this.activity,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TerminateStreamBloc>(),
      child: ActivityDetailsIosView(
        server: server,
        activity: activity,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class ActivityDetailsIosView extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;
  final String? previousPageTitle;

  const ActivityDetailsIosView({
    super.key,
    required this.server,
    required this.activity,
    this.previousPageTitle,
  });

  @override
  State<ActivityDetailsIosView> createState() => _ActivityDetailsIosViewState();
}

class _ActivityDetailsIosViewState extends State<ActivityDetailsIosView> {
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
            setState(() {
              // Update activity to most recent data and if the item no longer exists close the bottom sheet
              try {
                final activityList = state.serverActivityList
                    .firstWhere((server) => server.tautulliId == widget.server.tautulliId)
                    .activityList;
                final item = activityList.firstWhere(
                  (item) => item.sessionId == activity.sessionId && item.sessionKey == activity.sessionKey,
                );

                activity = item;
              } catch (_) {
                Navigator.of(context).pop();
              }
            });
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
              showFailureCupertinoAlertDialog(
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
            color: ThemeHelper.cupertinoNavigationBarItemColor(),
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
                          child: CachedNetworkImage(
                            imageUrl: posterUri.toString(),
                            httpHeaders: {
                              for (CustomHeaderModel headerModel
                                  in settingsState.appSettings.activeServer.customHeaders)
                                headerModel.key: headerModel.value,
                            },
                            imageBuilder: (context, imageProvider) => DecoratedBox(
                              position: DecorationPosition.foreground,
                              decoration: BoxDecoration(
                                color: CupertinoColors.black.withValues(alpha: 0.2),
                              ),
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 25,
                                  sigmaY: 25,
                                  tileMode: TileMode.decal,
                                ),
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Image.asset('assets/images/art_fallback.png'),
                            errorWidget: (context, url, error) => Image.asset('assets/images/art_error.png'),
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
                              child: ActivityDetailsIosPageInfo(activity: activity),
                            ),
                            //* Details
                            IosProgressBar(activity: activity),
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
                                            ProgressIosPercent(progressPercent: activity.progressPercent!),
                                          TimeIosTotal(
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
                              child: ActivityDetailsIosPageDetails(
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
                    child: IosPoster(
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
          child: Icon(
            CupertinoIcons.person_fill,
            color: ThemeHelper.cupertinoNavigationBarItemColor(),
          ),
          onPressed: () {
            final user = UserModel(
              friendlyName: activity.friendlyName,
              userId: activity.userId,
            );

            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => UserDetailsIosPage(
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
          child: Icon(
            CupertinoIcons.info_circle_fill,
            color: ThemeHelper.cupertinoNavigationBarItemColor(),
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
                builder: (context) => MediaIosPage(
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
                builder: (context) => TerminateStreamIosBottomSheet(
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
                    settingsBloc: context.read<SettingsBloc>(),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
