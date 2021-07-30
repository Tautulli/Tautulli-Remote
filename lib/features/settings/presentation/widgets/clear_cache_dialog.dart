import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../../cache/presentation/bloc/cache_bloc.dart';

Future<void> clearCacheDialog({
  @required BuildContext context,
  @required CacheBloc cacheBloc,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text(LocaleKeys.settings_clear_cache_title).tr(),
        content: const Text(
          LocaleKeys.settings_clear_cache_dialog_content,
        ).tr(),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_clear).tr(),
            onPressed: () {
              Navigator.of(context).pop();
              cacheBloc.add(CacheClear());
            },
          ),
        ],
      );
    },
  );
}
