import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../features/settings/data/models/custom_header_model.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../types/media_type.dart';
import '../base/image_gradient_background.dart';
import 'material_style_card.dart';
import 'material_style_poster.dart';

class MaterialStylePosterCard extends StatelessWidget {
  final MediaType? mediaType;
  final Uri? uri;
  final Widget details;
  final Function()? onTap;

  const MaterialStylePosterCard({
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialStyleCard(
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
                          MaterialStylePoster(mediaType: mediaType, uri: uri),
                          const Gap(8),
                          Expanded(child: details),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                      ),
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
