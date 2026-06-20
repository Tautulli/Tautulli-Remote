import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/material/material_style_card.dart';
import '../../../../../core/widgets/material/material_style_poster.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../pages/material/material_style_activity_details_page.dart';
import '../base/activity_details.dart';
import '../base/progress_bar.dart';

class MaterialStyleActivityCard extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const MaterialStyleActivityCard({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<MaterialStyleActivityCard> createState() => _MaterialStyleActivityCardState();
}

class _MaterialStyleActivityCardState extends State<MaterialStyleActivityCard> {
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
      child: MaterialStyleCard(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (previous, current) {
            if (previous is SettingsSuccess && current is SettingsSuccess) {
              return previous.appSettings.disableImageBackgrounds != current.appSettings.disableImageBackgrounds ||
                  previous.appSettings.activeServer.customHeaders != current.appSettings.activeServer.customHeaders;
            }
            return true;
          },
          builder: (context, state) {
            state as SettingsSuccess;

            return Stack(
              children: [
                if (!state.appSettings.disableImageBackgrounds && widget.activity.imageUri != null)
                  Positioned.fill(
                    child: ImageGradientBackground(
                      imageUri: posterUri,
                      httpHeaders: {
                        for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                          headerModel.key: headerModel.value,
                      },
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
                              MaterialStylePoster(
                                mediaType: widget.activity.mediaType,
                                uri: posterUri,
                                activityState: widget.activity.state,
                              ),
                              const Gap(8),
                              Expanded(
                                child: ActivityDetails(
                                  activity: widget.activity,
                                  iconColor: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ProgressBar(
                          activity: widget.activity,
                          backgroundColor: Colors.black26,
                          transcodeColor: Theme.of(context).colorScheme.onSurface,
                          progressColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: _activityBloc,
                            child: MaterialStyleActivityDetailsPage(
                              server: widget.server,
                              activity: widget.activity,
                            ),
                          ),
                        ),
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
