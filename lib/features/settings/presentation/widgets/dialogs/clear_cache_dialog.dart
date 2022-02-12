import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc.dart';

class ClearCacheDialog extends StatelessWidget {
  const ClearCacheDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Clear Image Cache'),
      content: const Text('Are you sure you want to clear the cache?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            context.read<SettingsBloc>().add(SettingsClearCache());
            Navigator.of(context).pop(true);
          },
          child: const Text('CLEAR'),
        ),
      ],
    );
  }
}
