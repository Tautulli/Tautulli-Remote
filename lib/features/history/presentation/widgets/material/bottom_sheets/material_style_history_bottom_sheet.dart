import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/device_info/device_info.dart';
import '../../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../../core/widgets/material/material_style_gesture_pill.dart';
import '../../../../../../core/widgets/material/material_style_poster.dart';
import '../../../../../../dependency_injection.dart' as di;
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../media/data/models/media_model.dart';
import '../../../../../media/presentation/pages/material/material_style_media_page.dart';
import '../../../../../settings/data/models/custom_header_model.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../../users/data/models/user_model.dart';
import '../../../../../users/presentation/pages/material/material_style_user_details_page.dart';
import '../../../../data/models/history_model.dart';
import '../../base/history_details_info.dart';
import '../material_style_history_bottom_sheet_details.dart';

class MaterialStyleHistoryBottomSheet extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const MaterialStyleHistoryBottomSheet({
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
                                          child: ImageGradientBackground(
                                            imageUri: history.posterUri,
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
                                                  child: HistoryDetailsInfo(
                                                    history: history,
                                                    fontSize: 17,
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
                      child: MaterialStylePoster(
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
                        child: MaterialStyleHistoryBottomSheetDetails(
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
                                          builder: (context) => MaterialStyleUserDetailsPage(
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
                                          builder: (context) => MaterialStyleMediaPage(
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
