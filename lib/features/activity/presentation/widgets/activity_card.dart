import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../../../core/widgets/poster.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';
import '../bloc/activity_bloc.dart';
import '../bloc/terminate_stream_bloc.dart';
import 'activity_bottom_sheet.dart';
import 'activity_details.dart';
import 'progress_bar.dart';

class ActivityCard extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const ActivityCard({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
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
      child: CardWithForcedTint(
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
                        for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders) headerModel.key: headerModel.value,
                      },
                      imageBuilder: (context, imageProvider) => DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
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
                              Poster(
                                mediaType: widget.activity.mediaType,
                                uri: posterUri,
                                activityState: widget.activity.state,
                              ),
                              const Gap(8),
                              Expanded(
                                child: ActivityDetails(
                                  activity: widget.activity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ProgressBar(activity: widget.activity),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        builder: (context) {
                          return BlocProvider.value(
                            value: _activityBloc,
                            child: BlocProvider(
                              create: (context) => di.sl<TerminateStreamBloc>(),
                              child: ActivityBottomSheet(
                                server: widget.server,
                                activity: widget.activity,
                              ),
                            ),
                          );
                        },
                      ),
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
}
