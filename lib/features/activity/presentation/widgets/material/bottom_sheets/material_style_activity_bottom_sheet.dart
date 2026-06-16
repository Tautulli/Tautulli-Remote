import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/types/media_type.dart';
import '../../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../../core/widgets/material/dialogs/material_style_failure_alert_dialog.dart';
import '../../../../../../core/widgets/material/material_style_gesture_pill.dart';
import '../../../../../../core/widgets/material/material_style_poster.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../media/data/models/media_model.dart';
import '../../../../../media/presentation/pages/material/material_style_media_page.dart';
import '../../../../../settings/data/models/custom_header_model.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../../users/data/models/user_model.dart';
import '../../../../../users/presentation/pages/material/material_style_user_details_page.dart';
import '../../../../data/models/activity_model.dart';
import '../../../bloc/activity_bloc.dart';
import '../../../bloc/terminate_stream_bloc.dart';
import '../../base/progress_bar.dart';
import '../dialogs/material_style_terminate_stream_dialog.dart';
import '../material_style_progress_percent.dart';
import '../material_style_time_eta.dart';
import '../material_style_time_total.dart';
import 'material_style_activity_bottom_sheet_details.dart';
import 'material_style_activity_bottom_sheet_info.dart';

class MaterialStyleActivityBottomSheet extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const MaterialStyleActivityBottomSheet({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<MaterialStyleActivityBottomSheet> createState() => _MaterialStyleActivityBottomSheetState();
}

class _MaterialStyleActivityBottomSheetState extends State<MaterialStyleActivityBottomSheet> {
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
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(LocaleKeys.termination_request_sent_message).tr(),
                  action: SnackBarAction(
                    label: LocaleKeys.learn_more_title.tr(),
                    onPressed: () async {
                      await launchUrlString(
                        mode: LaunchMode.externalApplication,
                        'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#termination_caveats',
                      );
                    },
                  ),
                ),
              );
            }
            if (state is TerminateStreamFailure) {
              showFailureAlertDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
        ),
      ],
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IntrinsicHeight(
            child: Column(
              children: [
                // Add spacing above bottom sheet to account for status bar height.
                // Allows for that area to be tapped to dismiss the modal bottom
                // sheet but not be dragged down. Must be a container with
                // transparent color for this to work.
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  onVerticalDragDown: (_) {},
                  child: Container(
                    height: MediaQueryData.fromView(View.of(context)).padding.top,
                    color: Colors.transparent,
                  ),
                ),
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
                            color: Colors.transparent,
                          ),
                        ),
                        ClipRRect(
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
                                          color: Theme.of(context).colorScheme.surface,
                                        ),
                                      ),
                                    ),
                                    (state.appSettings.disableImageBackgrounds)
                                        ? Positioned.fill(
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.2),
                                              ),
                                            ),
                                          )
                                        : Positioned.fill(
                                            child: ImageGradientBackground(
                                              imageUri: posterUri,
                                              httpHeaders: {
                                                for (CustomHeaderModel headerModel
                                                    in state.appSettings.activeServer.customHeaders)
                                                  headerModel.key: headerModel.value,
                                              },
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
                                                    child: MaterialStyleGesturePill(),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 100,
                                                      right: 8,
                                                    ),
                                                    child: MaterialStyleActivityBottomSheetInfo(
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
                                                          activity.friendlyName ?? '',
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ).sensitive(),
                                                      ),
                                                      if (activity.live != true &&
                                                          activity.duration != null &&
                                                          activity.viewOffset != null &&
                                                          activity.duration != null)
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            MaterialStyleTimeEta(
                                                              server: widget.server,
                                                              activity: activity,
                                                            ),
                                                            Row(
                                                              children: [
                                                                if (activity.progressPercent != null) ...[
                                                                  MaterialStyleProgressPercent(
                                                                    progressPercent: activity.progressPercent!,
                                                                  ),
                                                                  const Text(' • '),
                                                                ],
                                                                MaterialStyleTimeTotal(
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
                                                  child: ProgressBar(
                                                    activity: activity,
                                                    backgroundColor: Colors.black26,
                                                    transcodeColor: Theme.of(context).colorScheme.onSurface,
                                                    progressColor: Theme.of(context).colorScheme.primaryContainer,
                                                  ),
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
                        child: MaterialStylePoster(
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
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: MaterialStyleActivityBottomSheetDetails(
                            server: widget.server,
                            activity: activity,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                                onPressed: () {
                                  final user = UserModel(
                                    friendlyName: activity.friendlyName,
                                    userId: activity.userId,
                                  );

                                  Navigator.of(context).pop();

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MaterialStyleUserDetailsPage(
                                        server: widget.server,
                                        user: user,
                                        fetchUser: true,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(LocaleKeys.user_title).tr(),
                              ),
                            ),
                            if (activity.mediaType != MediaType.photo)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
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

                                      Navigator.of(context).pop();

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MaterialStyleMediaPage(
                                            server: widget.server,
                                            media: media,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(LocaleKeys.media_title).tr(),
                                  ),
                                ),
                              ),
                            if (widget.server.plexPass == true && activity.mediaType != MediaType.photo)
                              BlocBuilder<TerminateStreamBloc, TerminateStreamState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.errorContainer,
                                        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                                      ),
                                      onPressed: () async {
                                        final TextEditingController controller = TextEditingController();

                                        final bool confirm = await showTerminateSessionDialog(
                                          activity: activity,
                                          controller: controller,
                                          context: context,
                                        );

                                        if (confirm) {
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
                                      child: const FaIcon(FontAwesomeIcons.xmark),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.viewPaddingOf(context).bottom),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
