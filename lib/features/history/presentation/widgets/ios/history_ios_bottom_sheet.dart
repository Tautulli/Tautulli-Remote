import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/widgets/ios/ios_gesture_pill.dart';
import '../../../../../core/widgets/ios/ios_poster.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/history_model.dart';
import '../history_bottom_sheet_info.dart';
import 'history_ios_bottom_sheet_details.dart';

class HistoryIosBottomSheet extends StatelessWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const HistoryIosBottomSheet({
    super.key,
    required this.server,
    required this.history,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                                          imageUrl: history.posterUri.toString(),
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
                child: IosPoster(
                  mediaType: history.mediaType,
                  uri: history.posterUri,
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
                  child: HistoryIosBottomSheetDetails(
                    server: server,
                    history: history,
                  ),
                ),
                SafeArea(
                  child: Row(
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
                      const Gap(6),
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
