import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/settings_bloc.dart';

class ClearAppImageCacheDialog extends StatelessWidget {
  const ClearAppImageCacheDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.clear_app_image_cache_title).tr(),
      content: const Text(LocaleKeys.clear_app_image_cache_dialog_content).tr(),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            context.read<SettingsBloc>().add(SettingsClearCache());
            Navigator.of(context).pop(true);
          },
          child: const Text(LocaleKeys.clear_title).tr(),
        ),
      ],
    );
  }
}
