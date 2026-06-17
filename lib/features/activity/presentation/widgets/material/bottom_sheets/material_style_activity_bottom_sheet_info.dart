import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/types/media_type.dart';
import '../../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../data/models/activity_model.dart';
import '../../base/activity_info_widgets.dart';

class MaterialStyleActivityBottomSheetInfo extends StatelessWidget {
  final ActivityModel activity;

  const MaterialStyleActivityBottomSheetInfo({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleRow(activity),
        if ([MediaType.episode, MediaType.track, MediaType.clip].contains(activity.mediaType)) SubtitleRow(activity),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return ItemDetailsRow(
              activity,
              dateFormat: state.appSettings.activeServer.dateFormat,
            );
          },
        ),
      ],
    );
  }
}
