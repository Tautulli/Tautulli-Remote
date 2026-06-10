import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../features/settings/data/models/custom_header_model.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../types/media_type.dart';
import '../base/image_gradient_background.dart';
import 'cupertino_style_card.dart';
import 'cupertino_style_poster.dart';

class CupertinoStylePosterCard extends StatelessWidget {
  final MediaType? mediaType;
  final Uri? uri;
  final Widget details;
  final Function()? onTap;

  const CupertinoStylePosterCard({
    super.key,
    this.mediaType,
    this.uri,
    required this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 100 * MediaQuery.of(context).textScaler.scale(1) : 100,
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(12),
        child: CupertinoStyleCard(
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              return Stack(
                children: [
                  if (!state.appSettings.disableImageBackgrounds && uri != null)
                    Positioned.fill(
                      child: ImageGradientBackground(
                        imageUri: uri,
                        httpHeaders: {
                          for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                            headerModel.key: headerModel.value,
                        },
                      ),
                    ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CupertinoStylePoster(mediaType: mediaType, uri: uri),
                          const Gap(8),
                          Expanded(child: details),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
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
