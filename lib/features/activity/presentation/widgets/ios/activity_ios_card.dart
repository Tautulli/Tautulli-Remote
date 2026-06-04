import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/cupertino_card.dart';
import '../../../../../core/widgets/ios/ios_poster.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../bloc/terminate_stream_bloc.dart';
import 'activity_ios_bottom_sheet.dart';
import 'ios_activity_details.dart';
import 'ios_progress_bar.dart';

class ActivityIosCard extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const ActivityIosCard({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<ActivityIosCard> createState() => _ActivityIosCardState();
}

class _ActivityIosCardState extends State<ActivityIosCard> {
  late ActivityBloc _activityBloc;

  @override
  void initState() {
    super.initState();
    _activityBloc = context.read<ActivityBloc>();
  }

  @override
  Widget build(BuildContext context) {
    late Uri? posterUri;

    switch (widget.activity.mediaType) {
      case (MediaType.episode):
        posterUri = widget.activity.grandparentImageUri;
        break;
      default:
        posterUri = widget.activity.imageUri;
    }

    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 135 * MediaQuery.of(context).textScaler.scale(1) : 135,
      child: GestureDetector(
        onTap: () => showCupertinoSheet(
          context: context,
          builder: (context) {
            return BlocProvider.value(
              value: _activityBloc,
              child: BlocProvider(
                create: (context) => di.sl<TerminateStreamBloc>(),
                child: ActivityIosBottomSheet(
                  server: widget.server,
                  activity: widget.activity,
                ),
              ),
            );
          },
        ),
        child: CupertinoCard(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              return Stack(
                children: [
                  if (!state.appSettings.disableImageBackgrounds && widget.activity.imageUri != null)
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: posterUri.toString(),
                        httpHeaders: {
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                            headerModel.key: headerModel.value,
                        },
                        imageBuilder: (context, imageProvider) => DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            color: CupertinoColors.black.withValues(alpha: 0.4),
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
                        placeholder: (context, url) => ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 25,
                            sigmaY: 25,
                            tileMode: TileMode.decal,
                          ),
                          child: Image.asset(
                            'assets/images/poster_fallback.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        errorWidget: (context, url, error) => ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 25,
                            sigmaY: 25,
                            tileMode: TileMode.decal,
                          ),
                          child: Image.asset(
                            'assets/images/poster_error.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IosPoster(
                                  mediaType: widget.activity.mediaType,
                                  uri: posterUri,
                                  activityState: widget.activity.state,
                                ),
                                const Gap(8),
                                Expanded(
                                  child: IosActivityDetails(
                                    activity: widget.activity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: IosProgressBar(activity: widget.activity),
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
    );
  }
}
