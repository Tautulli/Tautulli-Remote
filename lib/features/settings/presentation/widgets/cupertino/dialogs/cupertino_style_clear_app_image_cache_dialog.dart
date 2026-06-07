import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleClearAppImageCacheDialog extends StatelessWidget {
  const CupertinoStyleClearAppImageCacheDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(LocaleKeys.clear_app_image_cache_title).tr(),
      content: const Text(LocaleKeys.clear_app_image_cache_dialog_content).tr(),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(LocaleKeys.cancel_title).tr(),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
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
