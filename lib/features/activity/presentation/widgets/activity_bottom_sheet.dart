import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/gesture_pill.dart';
import '../../../../core/widgets/poster.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../media/data/models/media_model.dart';
import '../../../media/presentation/pages/media_page.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/pages/user_details_page.dart';
import '../../data/models/activity_model.dart';
import 'activity_bottom_sheet_details.dart';
import 'activity_bottom_sheet_info.dart';
import 'progress_bar.dart';
import 'time_total.dart';

class ActivityBottomSheet extends StatelessWidget {
  final ActivityModel activity;

  const ActivityBottomSheet({
    super.key,
    required this.activity,
  });

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

    return Padding(
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
                height: MediaQueryData.fromWindow(window).padding.top,
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
                        child: Stack(
                          children: [
                            //* Background
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: BlocBuilder<SettingsBloc, SettingsState>(
                                builder: (context, state) {
                                  state as SettingsSuccess;

                                  return DecoratedBox(
                                    position: DecorationPosition.foreground,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
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
                                  );
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
                                            child: GesturePill(),
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
                                            children: [
                                              BlocBuilder<SettingsBloc, SettingsState>(
                                                builder: (context, state) {
                                                  state as SettingsSuccess;

                                                  return Expanded(
                                                    child: Text(
                                                      state.appSettings.maskSensitiveInfo
                                                          ? LocaleKeys.hidden_message.tr()
                                                          : activity.friendlyName ?? '',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              if (activity.live != true &&
                                                  activity.duration != null &&
                                                  activity.viewOffset != null &&
                                                  activity.duration != null)
                                                TimeTotal(
                                                  viewOffset: activity.viewOffset!,
                                                  duration: activity.duration!,
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
                                          child: ProgressBar(activity: activity),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                    child: Poster(
                      mediaType: activity.mediaType,
                      uri: posterUri,
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
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ActivityBottomSheetDetails(activity: activity),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final user = UserModel(
                                friendlyName: activity.friendlyName,
                                userId: activity.userId,
                              );

                              Navigator.of(context).pop();

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(
                                    user: user,
                                    fetchUser: true,
                                  ),
                                ),
                              );
                            },
                            child: const Text(LocaleKeys.view_user_title).tr(),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PlexColorPalette.curiousBlue,
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
                                  builder: (context) => MediaPage(
                                    media: media,
                                  ),
                                ),
                              );
                            },
                            child: const Text(LocaleKeys.view_media_title).tr(),
                          ),
                        ),
                        // const Gap(8),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Theme.of(context).colorScheme.error,
                        //   ),
                        //   onPressed: () {},
                        //   child: FaIcon(FontAwesomeIcons.xmark),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
