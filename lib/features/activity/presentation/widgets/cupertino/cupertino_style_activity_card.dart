import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_poster.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../pages/cupertino/cupertino_style_activity_details_page.dart';
import '../base/activity_details.dart';
import '../base/progress_bar.dart';

class CupertinoStyleActivityCard extends StatelessWidget {
  final ServerModel server;
  final ActivityModel activity;

  const CupertinoStyleActivityCard({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    late Uri? posterUri;

    switch (activity.mediaType) {
      case (MediaType.episode):
        posterUri = activity.grandparentImageUri;
        break;
      default:
        posterUri = activity.imageUri;
    }

    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 135 * MediaQuery.of(context).textScaler.scale(1) : 135,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<ActivityBloc>(),
              child: CupertinoStyleActivityDetailsPage(
                activity: activity,
                server: server,
                previousPageTitle: LocaleKeys.activity_title.tr(),
              ),
            ),
          ),
        ),
        child: CupertinoStyleCard(
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
                  if (!state.appSettings.disableImageBackgrounds && activity.imageUri != null)
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
                                CupertinoStylePoster(
                                  mediaType: activity.mediaType,
                                  uri: posterUri,
                                  activityState: activity.state,
                                ),
                                const Gap(8),
                                Expanded(
                                  child: ActivityDetails(
                                    activity: activity,
                                    iconColor: ThemeHelper.cupertinoCardIconColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ProgressBar(
                            activity: activity,
                            backgroundColor: CupertinoColors.black.withValues(alpha: 0.26),
                            transcodeColor: ThemeHelper.cupertinoCardIconColor,
                            progressColor: CupertinoTheme.of(context).primaryColor,
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
    );
  }
}
