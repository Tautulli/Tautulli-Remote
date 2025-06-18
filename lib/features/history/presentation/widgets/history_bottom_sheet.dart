import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/device_info/device_info.dart';
import '../../../../core/widgets/gesture_pill.dart';
import '../../../../core/widgets/poster.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../media/data/models/media_model.dart';
import '../../../media/presentation/pages/media_page.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/pages/user_details_page.dart';
import '../../data/models/history_model.dart';
import 'history_bottom_sheet_details.dart';
import 'history_bottom_sheet_info.dart';

class HistoryBottomSheet extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const HistoryBottomSheet({
    super.key,
    required this.server,
    required this.history,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                          height: 28,
                          color: Colors.transparent,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: SizedBox(
                          height: 110,
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
                                          child: DecoratedBox(
                                            position: DecorationPosition.foreground,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.2),
                                            ),
                                            child: ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 25,
                                                sigmaY: 25,
                                                tileMode: TileMode.decal,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: history.posterUri.toString(),
                                                httpHeaders: {
                                                  for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
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
                                                  child: GesturePill(),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 100,
                                                    right: 8,
                                                  ),
                                                  child: HistoryBottomSheetInfo(
                                                    history: history,
                                                  ),
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
                      child: Poster(
                        mediaType: history.mediaType,
                        uri: history.posterUri,
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
                        child: HistoryBottomSheetDetails(
                          server: server,
                          history: history,
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
                              onPressed: viewUserEnabled
                                  ? () {
                                      final user = UserModel(
                                        friendlyName: history.friendlyName,
                                        userId: history.userId,
                                      );

                                      Navigator.of(context).pop();

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => UserDetailsPage(
                                            server: server,
                                            user: user,
                                            fetchUser: true,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Text(LocaleKeys.view_user_title).tr(),
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
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

                                      Navigator.of(context).pop();

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MediaPage(
                                            server: server,
                                            media: media,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Text(LocaleKeys.view_media_title).tr(),
                            ),
                          ),
                        ],
                      ),
                      if (di.sl<DeviceInfo>().platform == 'ios') const Gap(8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
