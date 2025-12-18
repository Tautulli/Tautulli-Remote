import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/device_info/device_info.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/failure_cupertino_alert_dialog.dart';
import '../../../../../core/widgets/ios/ios_gesture_pill.dart';
import '../../../../../core/widgets/ios/ios_poster.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../bloc/terminate_stream_bloc.dart';
import '../activity_bottom_sheet_info.dart';
import '../progress_percent.dart';
import '../time_eta.dart';
import '../time_total.dart';
import 'activity_ios_bottom_sheet_details.dart';
import 'ios_progress_bar.dart';
import 'terminate_stream_ios_bottom_sheet.dart';

class ActivityIosBottomSheet extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const ActivityIosBottomSheet({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<ActivityIosBottomSheet> createState() => _ActivityIosBottomSheetState();
}

class _ActivityIosBottomSheetState extends State<ActivityIosBottomSheet> {
  late ActivityModel activity;

  @override
  void initState() {
    super.initState();
    activity = widget.activity;
  }

  @override
  Widget build(BuildContext context) {
    late Uri? posterUri;

    switch (activity.mediaType) {
      case (MediaType.episode):
        posterUri = activity.grandparentImageUri;
        break;
      default:
        posterUri = activity.imageUri;
    }

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
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  // Creates a transparent area for the poster to hover over.
                  // Allows for that area to be tapped to dismiss the modal bottom
                  // sheet but not be dragged down. Must be a container with
                  // transparent color for this to work.
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    onVerticalDragDown: (_) {},
                    child: Container(
                      height: 14,
                      color: CupertinoColors.transparent,
                    ),
                  ),
                  ClipRSuperellipse(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: SizedBox(
                      height: 130,
                      child: BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          state as SettingsSuccess;

                          return Stack(
                            children: [
                              //* Background
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                              (state.appSettings.disableImageBackgrounds)
                                  ? Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.black.withValues(alpha: 0.2),
                                        ),
                                      ),
                                    )
                                  : Positioned.fill(
                                      child: DecoratedBox(
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
                                          child: CachedNetworkImage(
                                            imageUrl: posterUri.toString(),
                                            httpHeaders: {
                                              for (CustomHeaderModel headerModel
                                                  in state.appSettings.activeServer.customHeaders)
                                                headerModel.key: headerModel.value,
                                            },
                                            placeholder: (context, url) => Image.asset(
                                              'assets/images/poster_fallback.png',
                                            ),
                                            errorWidget: (context, url, error) => Image.asset(
                                              'assets/images/poster_error.png',
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                              //* Info Section
                              Positioned.fill(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                              top: 4,
                                              bottom: 2,
                                            ),
                                            child: Center(
                                              child: IosGesturePill(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 100,
                                                right: 8,
                                              ),
                                              child: ActivityBottomSheetInfo(
                                                activity: activity,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 100,
                                              right: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    state.appSettings.maskSensitiveInfo
                                                        ? LocaleKeys.hidden_message.tr()
                                                        : activity.friendlyName ?? '',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                if (activity.live != true &&
                                                    activity.duration != null &&
                                                    activity.viewOffset != null &&
                                                    activity.duration != null)
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      TimeEta(
                                                        server: widget.server,
                                                        activity: activity,
                                                      ),
                                                      Row(
                                                        children: [
                                                          if (activity.progressPercent != null) ...[
                                                            ProgressPercent(progressPercent: activity.progressPercent!),
                                                            const Text(' • '),
                                                          ],
                                                          TimeTotal(
                                                            viewOffset: activity.viewOffset!,
                                                            duration: activity.duration!,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                if (activity.live == true)
                                                  Text(
                                                    '${activity.channelCallSign}',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 4),
                                            child: IosProgressBar(activity: activity),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //* Poster
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: SizedBox(
                  height: 130,
                  child: IosPoster(
                    mediaType: activity.mediaType,
                    uri: posterUri,
                    activityState: activity.state,
                    opaqueBackground: true,
                  ),
                ),
              ),
            ],
          ),
          //* Details
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ActivityIosBottomSheetDetails(
                      server: widget.server,
                      activity: activity,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton.filled(
                              onPressed: () {
                                //TODO: Navigate to user
                              },
                              //TODO: Translation
                              child: Text('Go to User'),
                            ),
                          ),
                          Gap(6),
                          Expanded(
                            child: CupertinoButton.filled(
                              color: PlexColorPalette.blue,
                              onPressed: () {
                                //TODO: Navigate to media
                              },
                              //TODO: Translation
                              child: Text('Go to Media'),
                            ),
                          ),
                        ],
                      ),
                      // Gap(6),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: CupertinoButton.filled(
                      //         color: PlexColorPalette.blue,
                      //         onPressed: () {
                      //           //TODO: Navigate to user
                      //         },
                      //         child: Text('Go to Media'),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const Gap(6),
                      if (widget.server.plexPass == true && activity.mediaType != MediaType.photo)
                        Row(
                          children: [
                            Expanded(
                              child: BlocBuilder<TerminateStreamBloc, TerminateStreamState>(
                                builder: (context, state) {
                                  return CupertinoButton.filled(
                                    color: CupertinoColors.destructiveRed,
                                    onPressed: () async {
                                      final TextEditingController controller = TextEditingController();

                                      final bool? confirm = await showCupertinoSheet(
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
                                    //TODO: Translation
                                    child: const Text('Terminate Stream'),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      const Gap(16),
                    ],
                  ),
                  if (di.sl<DeviceInfo>().platform == 'ios') const Gap(8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
